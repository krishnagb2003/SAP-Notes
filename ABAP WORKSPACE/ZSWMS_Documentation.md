# Smart Workforce Management System (ZSWMS)

This repository contains the high-fidelity interactive prototype for the **Smart Workforce Management System**, designed with SAP Fiori aesthetics.

## 🚀 Quick Start
To view the prototype, simply double-click the **`ZSWMS_PROTOTYPE.html`** file to open it in your web browser (Chrome, Edge, Safari, etc.). No local server or build tools are required as it uses vanilla HTML/CSS/JS.

---

## 🏗️ Architecture Simulator

This prototype simulates a real-world SAP Gateway (OData) + ABAP Backend architecture entirely within the browser using JavaScript. 

### 1. The Frontend (React/Vercel Simulated)
- **UI Framework:** Vanilla HTML/CSS replicating **SAP Fiori**.
- **Routing:** Handled entirely client-side via JavaScript DOM manipulation to switch between the 8 core modules seamlessly.
- **Charts:** Uses Chart.js (included via CDN) to render Dashboard visualizations.

### 2. The OData Layer (Simulated `ZSWMS_SRV`)
All HTTP Fetch/Axios calls are simulated using JavaScript Promises.
- `OData.getEmployeeSet()` → Fetches Employee Data
- `OData.getContractSet()` → Fetches Contract Data (auto-calculates statuses)
- `OData.getTaskSet()` → Fetches Kanban Tasks
- `OData.getProjectSet()` → Fetches Active Projects
- `OData.getNotificationSet()` → Fetches SAP Inbox Alerts
- `OData.getTimelineSet(empId)` → Aggregates a user's entire history timeline.

### 3. The ABAP Backend (Simulated Business Logic)
Function Modules are simulated as pure JavaScript functions executing logic before passing data to the frontend:
- **`Z_CALC_CONTRACT_STATUS`**: Analyzes the difference between the current date and contract end date. Classifies the status as `Active`, `Expiring Soon` (8-30 days), `Critical` (≤ 7 days), or `Expired`.
- **`Z_AI_SUMMARIZE_EMPLOYEE`**: Simulates an OpenAI API call by aggregating the user's role, tasks, project assignments, and contract status into a written business recommendation paragraph.

### 4. SAP Z Tables (Simulated DDIC)
To emulate an SAP backend, data is stored in a structured JSON schema reflecting typical SE11 database tables:
- **`ZSWMS_EMPLOYEE`**: Core user records.
- **`ZSWMS_CONTRACT`**: Start dates, end dates, and contract types.
- **`ZSWMS_TASK`**: Priority, status, and deadlines.
- **`ZSWMS_PROJECT`**: Client data and life cycles.
- **`ZSWMS_EMP_PROJECT`**: Mapping table linking employees to specific projects.
- **`ZSWMS_NOTIFICATION`**: Notification log including `IS_READ` flags.

---

## 🧩 Modules Included
1. **Dashboard**: High-level KPIs, Contract Doughnut Chart, and Task Distribution Bar Chart.
2. **Employee Management**: Master data table with responsive status pills.
3. **Timeline**: Vertical history timeline tracking an employee's journey (Joining, Projects, Contract Renewals, Tasks).
4. **Contract Management**: Central view of all agreements and live calculated countdowns (`Days Remaining`).
5. **Tasks Management**: 3-Column Kanban board (`Pending`, `In Progress`, `Completed`).
6. **Projects Overview**: Client card view and resource allocation.
7. **Notifications**: System Alerts for anniversaries, risks, and expirations.
8. **AI Summary Engine**: Generates a fast, intelligence-driven overview of a single employee's status to aid in HR management decisions.

---

## ✨ UI/UX Enhancements (v1.1)
- **Fiori Message Toasts**: Added a floating toast notification system (`sap-toast`) to provide immediate feedback when users initiate actions (e.g., generating AI summaries or marking notifications as read).
- **Dark Mode (Horizon Theme)**: Added a one-click theme toggler in the Shell bar (Moon icon) to switch the UI into SAP's modern Horizon Dark Theme, showcasing customized CSS variables at work.
- **Export capabilities**: Embedded conceptual 'Export to Excel' buttons into the Employee and Contract modules to emulate essential SAP reporting feature requirements.
