# 🧑‍💻 Copilot Instructions for Engo

Welcome, AI coding agents! This document provides guidelines for contributing to the Engo English Learning App codebase. Please follow these instructions to ensure consistency, maintainability, and alignment with the project's dynamic, data-driven architecture.

---

## 📦 Project Overview
- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Architecture:** Modular (separate data, controller, and UI files)
- **Navigation:** Roadmap UI with icons, each launching a sequence of three quiz screens (Screen1, Screen2, Screen3)
- **Data:** Multi-dimensional lists for quiz content, supporting multiple groups (icons) and levels

---

## 🏗️ Coding Guidelines

### 1. **Dynamic Data-Driven Screens**
- **Do NOT** duplicate code for quiz screens. All quiz screens (`Screen1`, `Screen2`, `Screen3`) and their controllers must be reused for every roadmap icon/level.
- **Data files** (e.g., `Screen1_data.dart`) are structured as `List<List<List<Map<String, String>>>>` for `[group][level][word]` access.
- **Controllers** (e.g., `Screen1Controller`) and **screens** must accept `groupIndex` and `levelIndex` as parameters to select the correct data at runtime.
- **Navigation** must pass these indexes to the screens/controllers.

### 2. **File Structure**
- Place new screens in `lib/screens/`
- Place new controllers in `lib/road map/` or `lib/screens/`
- Place new data files in `lib/road map/`
- Assets (images, sounds) go in `assets/images/` and `assets/sounds/`

### 3. **State Management**
- Use GetX for all state and navigation logic.
- Controllers should be instantiated with the correct `groupIndex` and `levelIndex`.

### 4. **UI/UX**
- Follow the existing modern, responsive design.
- Support RTL for Arabic where appropriate.

### 5. **Testing & Validation**
- Ensure all new features are accessible via the roadmap navigation.
- Do not break dynamic data selection for any group/level.

---

## 🚦 Example: Adding a New Quiz Type
1. Create a new data file as a multi-dimensional list: `[group][level][item]`.
2. Create a controller that accepts `groupIndex` and `levelIndex`.
3. Create a screen that accepts these indexes and passes them to the controller.
4. Update roadmap navigation to launch the new screen with the correct indexes.

---

## 🛑 Anti-Patterns
- ❌ Hardcoding data or indexes in screens/controllers
- ❌ Duplicating quiz screen or controller code for each icon/level
- ❌ Static navigation to quiz screens without passing indexes

---

## 📝 Documentation
- Update this file with any new architectural patterns or onboarding tips for future AI agents.
- Reference the main `README.md` for project setup and feature overview.

---

## 🤖 AI Agent Best Practices
- Always prefer dynamic, reusable code over duplication.
- Validate that all navigation and data selection is index-driven.
- Ask for clarification if project patterns are unclear.

---

Thank you for helping make Engo better!