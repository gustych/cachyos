"""Exercise the CLI through isolated external process boundaries."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'bin/desktop-menu'


class DesktopMenuTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.tools = self.root / 'bin'
        self.tools.mkdir()
        self.env = dict(os.environ, HOME=str(self.root),
                        XDG_CONFIG_HOME=str(self.root / 'config'),
                        XDG_DATA_HOME=str(self.root / 'data'),
                        PATH=str(self.tools), CALL_LOG=str(self.root / 'calls'))
        for tool in ('fuzzel', 'systemctl', 'notify-send', 'wpctl', 'slurp', 'grim', 'wl-copy', 'hyprctl'):
            p = self.tools / tool
            p.write_text(f'''#!{os.sys.executable}
import json, os, sys
from pathlib import Path
name=Path(sys.argv[0]).name
with open(os.environ['CALL_LOG'], 'a') as f:
    f.write(json.dumps([name, *sys.argv[1:]])+'\\n')
if name=='fuzzel':
    if '--dmenu' in sys.argv: sys.stdin.read()
    print(os.environ.get('CHOICE', ''))
    sys.exit(int(os.environ.get('MENU_EXIT', '0')))
if name=='notify-send': sys.exit(int(os.environ.get('NOTIFY_EXIT', '0')))
if name=='slurp':
    if os.environ.get('SLURP_ERROR'): print(os.environ['SLURP_ERROR'], file=sys.stderr)
    print('10,20 30x40')
    sys.exit(int(os.environ.get('SLURP_EXIT', '0')))
if name=='grim': sys.stdout.buffer.write(b'PNG image')
if name=='wl-copy':
    Path(os.environ['HOME'], 'clipboard').write_bytes(sys.stdin.buffer.read())
''')
            p.chmod(0o755)

    def run_menu(self, *args, **env):
        return subprocess.run([os.sys.executable, str(SCRIPT), *args],
                              env=self.env | env, capture_output=True, text=True)

    def calls(self):
        p = self.root / 'calls'
        return [json.loads(line) for line in p.read_text().splitlines()] if p.exists() else []

    def test_reboot_cancellation_never_calls_systemctl(self):
        result = self.run_menu('reboot', CHOICE='Cancel')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(any(c[0] == 'systemctl' for c in self.calls()))

    def test_confirmed_reboot_calls_only_reboot(self):
        result = self.run_menu('reboot', CHOICE='Reboot')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(['systemctl', 'reboot'], self.calls())

    def test_free_text_cannot_execute_commands(self):
        result = self.run_menu('power', CHOICE='reboot; touch /tmp/unsafe')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(any(c[0] == 'systemctl' for c in self.calls()))

    def test_cancelled_capture_does_not_save_or_replace_clipboard(self):
        result = self.run_menu('screenshot', SLURP_EXIT='1')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse((self.root / 'clipboard').exists())
        self.assertFalse(list(self.root.rglob('*.png')))

    def test_cancelled_destination_discards_capture(self):
        result = self.run_menu('screenshot', CHOICE='Cancel')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse((self.root / 'clipboard').exists())
        self.assertFalse(list(self.root.rglob('*.png')))

    def test_copy_does_not_save_a_file(self):
        result = self.run_menu('screenshot', CHOICE='Copy')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / 'clipboard').read_bytes(), b'PNG image')
        self.assertFalse(list(self.root.rglob('*.png')))

    def test_save_and_copy_preserves_existing_images(self):
        for _ in range(2):
            result = self.run_menu('screenshot', CHOICE='Save and copy')
            self.assertEqual(result.returncode, 0, result.stderr)
        images = list((self.root / 'Pictures/Screenshots').glob('*.png'))
        self.assertEqual(len(images), 2)
        self.assertTrue(all(p.read_bytes() == b'PNG image' for p in images))
        self.assertEqual((self.root / 'clipboard').read_bytes(), b'PNG image')

    def test_missing_dependency_reports_failure(self):
        (self.tools / 'slurp').unlink()
        result = self.run_menu('screenshot')
        self.assertEqual(result.returncode, 1)
        self.assertIn('slurp is unavailable', result.stderr)
        self.assertTrue(any(c[0] == 'notify-send' for c in self.calls()))

    def test_escape_from_menu_does_not_dispatch(self):
        result = self.run_menu('power', MENU_EXIT='2')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(any(c[0] == 'systemctl' for c in self.calls()))

    def test_escape_from_app_launcher_is_quiet(self):
        result = self.run_menu('menu', MENU_EXIT='2')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(any(c[0] == 'notify-send' for c in self.calls()))

    def test_failed_menu_reports_error_instead_of_cancelling(self):
        result = self.run_menu('power', MENU_EXIT='1')
        self.assertEqual(result.returncode, 1)
        self.assertIn('Fuzzel menu failed', result.stderr)

    def test_failed_region_selection_reports_wayland_error(self):
        result = self.run_menu('screenshot', SLURP_EXIT='1', SLURP_ERROR='failed to create display')
        self.assertEqual(result.returncode, 1)
        self.assertIn('failed to create display', result.stderr)

    def test_notification_uses_compositor_when_no_daemon_is_running(self):
        (self.tools / 'slurp').unlink()
        result = self.run_menu('screenshot', NOTIFY_EXIT='1')
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any(c[:2] == ['hyprctl', 'notify'] for c in self.calls()))


if __name__ == '__main__':
    unittest.main()
