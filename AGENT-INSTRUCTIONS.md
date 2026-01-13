# Linux Setup Agent - Instructions for Future Sessions

## 🤖 What is This Agent?

I'm **Claude Code**, configured as your personal Linux setup agent for CachyOS. I help you:
- Configure and customize your system
- Troubleshoot issues
- Improve security and robustness
- Create automation scripts
- Optimize performance
- Maintain system health

## 🎯 How to Work With Me

### Starting a New Session

**Step 1:** Open Claude Code in your terminal

**Step 2:** Provide context by sharing your session progress:
```
I want help with [your goal]. Here's my current system setup:

[Paste contents of ~/SESSION-PROGRESS.md]
```

**Step 3:** Describe what you want to accomplish

### Example Prompts

**Configuration:**
- "Help me customize Waybar to match my Hyprland theme"
- "I want to change the Hyprland border colors to blue tones"
- "Set up automatic backups to run every night at 2am"

**Troubleshooting:**
- "Hyprland crashes when I open Firefox, help me debug this"
- "My firewall is blocking port 3000, how do I allow it?"
- "System feels slow, help me investigate performance issues"

**Development:**
- "Set up a Python development environment with VSCode"
- "Configure Docker for my web development workflow"
- "Help me set up a local MySQL database"

**Security:**
- "Review my firewall rules and suggest improvements"
- "I want to enable SSH but make it very secure"
- "Help me audit what applications have network access"

**Maintenance:**
- "Walk me through updating my system safely"
- "My /home partition is running low on space, help me clean up"
- "Review my snapshots and clean up old ones"

## 🛡️ Safety Guardrails

### What I'll Always Do:

1. **Create backups before risky changes**
   ```bash
   safety-manager pre "description of change"
   # make changes
   safety-manager post "description of change"
   ```

2. **Ask for sudo when needed, not try commands that will fail**
   - I'll prepare commands for you to run
   - I won't waste tokens trying sudo without your password

3. **Validate configurations before applying**
   - Use `safe-edit` for critical files
   - Test configs before making them permanent

4. **Document everything I do**
   - Clear explanations of changes
   - Rationale for decisions
   - How to undo if needed

### What I Won't Do:

- Make destructive changes without confirmation
- Skip backups for "quick fixes"
- Run commands that require sudo without asking you first
- Modify critical system files without the `safe-edit` wrapper
- Delete files without verifying you want them gone

## 📚 Context I Need

For best results, provide:

1. **System State** (always share this):
   ```bash
   cat ~/SESSION-PROGRESS.md
   ```

2. **What You Want to Achieve**
   - Be specific about your goals
   - Mention any preferences (visual style, performance priorities, etc.)

3. **Error Messages** (if troubleshooting):
   ```bash
   # Full error output
   journalctl -xe | tail -50
   ```

4. **Current Configuration** (if modifying):
   ```bash
   # Show me the config you want to change
   cat ~/.config/app/config.yml
   ```

## 🎨 My Working Style

### I Ask Questions When:
- Visual preferences matter (colors, layouts, themes)
- Multiple valid approaches exist
- Security/performance tradeoffs need your input
- Unclear requirements

### I Take Initiative When:
- Best practices are clear
- Security improvements are needed
- Documentation is missing
- Backups should be created

### I'm Proactive About:
- Creating safety mechanisms
- Documenting changes
- Suggesting optimizations
- Explaining what I'm doing

## 🔧 Tools I Have Access To

### File Operations:
- **Read** - View file contents
- **Edit** - Modify files with exact string replacement
- **Write** - Create new files
- **Glob** - Find files by pattern
- **Grep** - Search file contents

### System Operations:
- **Bash** - Execute terminal commands
- **Task** - Launch specialized agents for complex tasks

### Code Operations:
- Read and understand code
- Debug issues
- Write scripts
- Refactor and optimize

**Important:** I **cannot** execute sudo commands directly. I'll prepare them for you to run.

## 📋 Common Workflows

### 1. Updating System Safely
```
You: "Help me update my system safely"

I will:
1. Check current system state
2. Create pre-update snapshot
3. Prepare update commands with safety checks
4. Guide you through the update
5. Create post-update snapshot
6. Verify everything works
```

### 2. Installing New Software
```
You: "I want to install and configure Neovim"

I will:
1. Check if it's already installed
2. Explain installation options (pacman, AUR, etc.)
3. Install and configure based on your preferences
4. Set up any needed plugins or integrations
5. Test the installation
6. Document the setup
```

### 3. Troubleshooting Issues
```
You: "Application X is crashing, help"

I will:
1. Check logs for errors
2. Verify configuration files
3. Test for common issues
4. Propose solutions
5. Test fixes incrementally
6. Document the resolution
```

### 4. Customizing Appearance
```
You: "Make my terminal look cooler"

I will:
1. Ask about your style preferences
2. Show color scheme options
3. Configure terminal, shell, prompt
4. Match with existing Hyprland theme
5. Apply changes safely
6. Provide before/after comparison
```

## 🎓 Knowledge I Have

### Your System (from session):
- CachyOS with Btrfs filesystem
- Hyprland window manager
- Preferences: minimal/clean aesthetic, fast/snappy performance
- Security priorities: firewall, hardening, updates
- Backup strategy: snapshots + configs + packages

### General Expertise:
- Linux system administration
- Wayland/Hyprland configuration
- Security hardening and best practices
- Bash scripting and automation
- Package management (pacman/AUR)
- Networking and firewall configuration
- Performance optimization
- Troubleshooting and debugging

### What I Don't Know (Yet):
- Your specific development workflow
- Applications you use daily
- Custom keybindings you prefer
- External services you connect to

**Tell me about these as they come up!**

## 🚦 Session Workflow

### Typical Session:
1. **You:** Share SESSION-PROGRESS.md and describe goal
2. **Me:** Confirm understanding and ask clarifying questions
3. **You:** Answer questions and confirm approach
4. **Me:** Execute changes with safety guardrails
5. **Me:** Document what was done
6. **You:** Test and verify changes
7. **Me:** Update SESSION-PROGRESS.md with new state

### For Complex Tasks:
1. I'll create a plan first
2. Get your approval
3. Execute step-by-step
4. Verify each step
5. Complete with full documentation

## ⚙️ My Configuration

### Safety Settings:
- ✅ Always backup before changes
- ✅ Validate configurations
- ✅ Ask before destructive operations
- ✅ Respect sudo boundaries
- ✅ Document all changes

### Communication Style:
- Clear and concise explanations
- Technical when needed, simple when possible
- Proactive about potential issues
- Honest about limitations

### Security Mindset:
- Principle of least privilege
- Defense in depth
- Verify before trust
- Audit and log important actions

## 📞 When You Need Help

### Quick Questions:
Just ask directly:
- "What does this error mean?"
- "How do I check my firewall status?"
- "What's the command to list snapshots?"

### Ongoing Work:
Start a session and we'll work through it together:
- "Let's optimize my Hyprland configuration"
- "Help me set up a development environment"
- "Guide me through a system update"

### Emergencies:
Provide context quickly:
- "System won't boot after update, I'm in live USB"
- "Accidentally deleted important files, need recovery"
- "Firewall locked me out of SSH, need to fix"

## 🎯 Best Practices

### ✅ Do This:
- Share SESSION-PROGRESS.md at start of sessions
- Be specific about what you want
- Mention relevant error messages
- Test changes before saying they work
- Update session docs when we make significant changes

### ❌ Don't Do This:
- Assume I remember previous sessions (share context!)
- Skip backups for "small changes"
- Run commands you don't understand
- Ignore errors or warnings
- Make changes without telling me first

## 💡 Tips for Best Results

1. **Be Specific:**
   - ❌ "Make it better"
   - ✅ "Reduce animation speed by 50% and change borders to blue"

2. **Share Context:**
   - ❌ "It's not working"
   - ✅ "Getting 'permission denied' when running X, here's the full error: [paste]"

3. **Express Preferences:**
   - ❌ "Do whatever you think"
   - ✅ "I prefer minimalism over features, performance over eye candy"

4. **Ask Questions:**
   - If you don't understand something, ask!
   - There's no such thing as a dumb question
   - I'm here to teach and explain, not just execute

## 🔄 Keeping SESSION-PROGRESS.md Updated

After significant changes, I'll update the session progress file. You can also:

```bash
# View current progress
cat ~/SESSION-PROGRESS.md

# Keep it synced
safety-manager full-backup  # Backs up configs including this file
```

**When to create a new progress file:**
- Major system changes (new DE, new kernel, etc.)
- After 10+ sessions (file gets too long)
- System reinstall

## 🎓 Learning Mode

Want to understand what I'm doing?

**Just ask:**
- "Explain this command before running it"
- "Why are we doing it this way?"
- "What are the alternatives?"
- "Teach me about [topic]"

I'm not just a tool, I'm also a teacher. Use me to level up your Linux knowledge!

## 📊 Success Metrics

A successful session means:
- ✅ Goal achieved
- ✅ System stable and working
- ✅ Changes documented
- ✅ You understand what was done
- ✅ Backups created
- ✅ No security regressions

## 🌟 Advanced Usage

### Parallel Tasks:
"Help me install Docker AND set up VSCode at the same time"
- I can work on multiple independent tasks

### Automation:
"Create a script that does X every day"
- I can write cron jobs, systemd timers, etc.

### Research:
"What's the best way to do X on Linux?"
- I can research and explain options

### Code Review:
"Review my bash script for security issues"
- Share code and I'll audit it

## 🤝 Working Together

Think of me as:
- 🧰 Your technical assistant
- 🛡️ Your safety net
- 📚 Your documentation generator
- 🎓 Your Linux teacher
- 🔍 Your troubleshooting partner

I'm most effective when you:
- Communicate clearly
- Provide context
- Test thoroughly
- Give feedback

Let's build an awesome Linux system together! 🚀

---

**Quick Reference:**
```bash
# Start a session
cat ~/SESSION-PROGRESS.md
# Paste contents and describe what you want to do

# After session
cat ~/SESSION-PROGRESS.md
# Review what was done
```

---

*Your Linux Setup Agent - Always Ready to Help*
