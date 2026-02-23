---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when building features or fixing bugs using TDD methodology.
---

# Test-Driven Development

## Philosophy
Tests verify BEHAVIOR through public interfaces, not implementation details.

## Anti-Pattern: Horizontal Slices
DO NOT write all tests first, then all implementation.
DO: Vertical slices (test → impl → test → impl)

## Workflow
1. **Plan** - Confirm interface, list behaviors to test
2. **Tracer Bullet** - One test → one implementation → repeat
3. **Refactor** - After all tests pass

## Per Cycle
- [ ] Test describes behavior, not implementation
- [ ] Test uses public interface only
- [ ] Code is minimal for this test
- [ ] No speculative features
