#!/usr/bin/env python3

"""
LMStudio Benchmark Comparison Tool
Compares normal vs overclocked mode results and generates analysis report

Usage:
    python3 compare-benchmarks.py
    python3 compare-benchmarks.py /path/to/baseline /path/to/overclocked
"""

import json
import os
import sys
import glob
from pathlib import Path
from typing import Dict, List, Tuple
import csv

class BenchmarkComparator:
    def __init__(self, baseline_dir: str = None, overclocked_dir: str = None):
        benchmark_base = os.path.expanduser("~/.lmstudio-benchmarks")
        self.baseline_dir = baseline_dir or os.path.join(benchmark_base, "results", "baseline")
        self.overclocked_dir = overclocked_dir or os.path.join(benchmark_base, "results", "overclocked")
        self.results_base = os.path.join(benchmark_base, "results")

    def load_json_results(self, directory: str, pattern: str) -> List[Dict]:
        """Load JSON results matching pattern"""
        results = []
        if not os.path.exists(directory):
            print(f"Warning: Directory not found: {directory}")
            return results

        for filepath in glob.glob(os.path.join(directory, pattern)):
            try:
                with open(filepath, 'r') as f:
                    data = json.load(f)
                    results.append(data)
            except json.JSONDecodeError as e:
                print(f"Warning: Failed to parse {filepath}: {e}")
        return results

    def load_csv_results(self, directory: str, pattern: str) -> Dict[str, List[Dict]]:
        """Load CSV results matching pattern"""
        results = {}
        if not os.path.exists(directory):
            print(f"Warning: Directory not found: {directory}")
            return results

        for filepath in glob.glob(os.path.join(directory, pattern)):
            try:
                with open(filepath, 'r') as f:
                    reader = csv.DictReader(f)
                    filename = os.path.basename(filepath)
                    results[filename] = list(reader)
            except Exception as e:
                print(f"Warning: Failed to parse {filepath}: {e}")
        return results

    def calculate_statistics(self, values: List[float]) -> Dict[str, float]:
        """Calculate basic statistics"""
        if not values:
            return {}

        valid_values = [v for v in values if v is not None]
        if not valid_values:
            return {}

        return {
            'min': min(valid_values),
            'max': max(valid_values),
            'avg': sum(valid_values) / len(valid_values),
            'count': len(valid_values)
        }

    def compare_speed_tests(self) -> Dict:
        """Compare speed test results between modes"""
        baseline = self.load_json_results(self.baseline_dir, "speed-test-*.json")
        overclocked = self.load_json_results(self.overclocked_dir, "speed-test-*.json")

        comparison = {
            'baseline': baseline,
            'overclocked': overclocked,
            'improvements': {}
        }

        # Calculate improvements
        for bc in baseline:
            for oc in overclocked:
                if bc.get('model') == oc.get('model'):
                    if bc.get('success') and oc.get('success'):
                        baseline_throughput = bc.get('throughput_tokens_per_sec', 0)
                        oc_throughput = oc.get('throughput_tokens_per_sec', 0)

                        if baseline_throughput > 0:
                            improvement_pct = ((oc_throughput - baseline_throughput) / baseline_throughput) * 100
                            comparison['improvements'][bc.get('model')] = {
                                'baseline_throughput': baseline_throughput,
                                'oc_throughput': oc_throughput,
                                'improvement_percent': improvement_pct,
                                'speedup_factor': oc_throughput / baseline_throughput if baseline_throughput > 0 else 0
                            }

        return comparison

    def compare_thermal_tests(self) -> Dict:
        """Compare thermal test results between modes"""
        baseline = self.load_csv_results(self.baseline_dir, "thermal-test-*.csv")
        overclocked = self.load_csv_results(self.overclocked_dir, "thermal-test-*.csv")

        comparison = {
            'baseline_files': baseline,
            'overclocked_files': overclocked,
            'analysis': {}
        }

        # Analyze temperature trends
        for filename, baseline_data in baseline.items():
            if filename in overclocked:
                oc_data = overclocked[filename]

                baseline_temps = []
                oc_temps = []

                for row in baseline_data:
                    temp = row.get('cpu_temp_c', 'N/A')
                    if temp != 'N/A':
                        try:
                            baseline_temps.append(float(temp))
                        except ValueError:
                            pass

                for row in oc_data:
                    temp = row.get('cpu_temp_c', 'N/A')
                    if temp != 'N/A':
                        try:
                            oc_temps.append(float(temp))
                        except ValueError:
                            pass

                baseline_stats = self.calculate_statistics(baseline_temps)
                oc_stats = self.calculate_statistics(oc_temps)

                comparison['analysis'][filename] = {
                    'baseline_temps': baseline_stats,
                    'oc_temps': oc_stats,
                    'temp_increase': oc_stats.get('avg', 0) - baseline_stats.get('avg', 0) if baseline_stats and oc_stats else None
                }

        return comparison

    def generate_report(self) -> str:
        """Generate comparison report"""
        report = []
        report.append("=" * 70)
        report.append("LMStudio Benchmark Comparison Report")
        report.append("Normal Mode vs Overclocked Mode")
        report.append("=" * 70)
        report.append("")

        # Speed comparison
        speed_comparison = self.compare_speed_tests()
        report.append("SPEED TEST COMPARISON")
        report.append("-" * 70)

        if speed_comparison['improvements']:
            for model, data in speed_comparison['improvements'].items():
                report.append(f"Model: {model}")
                report.append(f"  Baseline:     {data['baseline_throughput']:.2f} tokens/sec")
                report.append(f"  Overclocked:  {data['oc_throughput']:.2f} tokens/sec")
                report.append(f"  Improvement:  {data['improvement_percent']:.1f}% faster")
                report.append(f"  Speedup:      {data['speedup_factor']:.2f}x")
                report.append("")
        else:
            report.append("No speed test results available for comparison")
        report.append("")

        # Thermal comparison
        thermal_comparison = self.compare_thermal_tests()
        report.append("THERMAL TEST COMPARISON")
        report.append("-" * 70)

        if thermal_comparison['analysis']:
            for test_name, analysis in thermal_comparison['analysis'].items():
                report.append(f"Test: {test_name}")

                if analysis['baseline_temps']:
                    report.append(f"  Baseline:  avg={analysis['baseline_temps'].get('avg', 0):.1f}°C, "
                                f"min={analysis['baseline_temps'].get('min', 0):.1f}°C, "
                                f"max={analysis['baseline_temps'].get('max', 0):.1f}°C")

                if analysis['oc_temps']:
                    report.append(f"  Overclocked: avg={analysis['oc_temps'].get('avg', 0):.1f}°C, "
                                f"min={analysis['oc_temps'].get('min', 0):.1f}°C, "
                                f"max={analysis['oc_temps'].get('max', 0):.1f}°C")

                if analysis['temp_increase'] is not None:
                    report.append(f"  Temperature increase: {analysis['temp_increase']:.1f}°C")

                report.append("")
        else:
            report.append("No thermal test results available for comparison")
        report.append("")

        # Summary and recommendations
        report.append("SUMMARY AND RECOMMENDATIONS")
        report.append("-" * 70)

        if speed_comparison['improvements']:
            avg_speedup = sum(data['speedup_factor']
                            for data in speed_comparison['improvements'].values()) / len(speed_comparison['improvements'])
            report.append(f"Average Speedup: {avg_speedup:.2f}x")

            if avg_speedup > 1.15:
                report.append("✓ Overclocking provides significant performance improvement (>15%)")
            elif avg_speedup > 1.05:
                report.append("~ Overclocking provides modest improvement (5-15%)")
            else:
                report.append("✗ Overclocking provides minimal improvement (<5%)")

        report.append("")

        # Check thermal impact
        max_temp_increase = max(
            (analysis.get('temp_increase') or 0)
            for analysis in thermal_comparison['analysis'].values()
        ) if thermal_comparison['analysis'] else 0

        report.append(f"Maximum Temperature Increase: {max_temp_increase:.1f}°C")
        if max_temp_increase > 15:
            report.append("⚠ High thermal impact - monitor cooling and stability")
        elif max_temp_increase > 10:
            report.append("~ Moderate thermal impact - ensure adequate cooling")
        else:
            report.append("✓ Low thermal impact")

        return "\n".join(report)

    def run(self):
        """Run comparison and generate report"""
        report = self.generate_report()
        print(report)

        # Save report to file
        report_file = os.path.join(self.results_base, "comparison-report.txt")
        with open(report_file, 'w') as f:
            f.write(report)
        print(f"\nReport saved to: {report_file}")

if __name__ == "__main__":
    baseline = None
    overclocked = None

    # Parse command line arguments
    if len(sys.argv) > 2:
        baseline = sys.argv[1]
        overclocked = sys.argv[2]

    comparator = BenchmarkComparator(baseline, overclocked)
    comparator.run()
