# 🌍 ANP-CODAS LocationApp Android 📍

Welcome to the **ANP-CODAS LocationApp** repository! This project combines the **CODAS** (COmbinative Distance-based ASsessment) and **ANP** (Analytic Network Process) methods to deliver a sophisticated, multi-criteria decision-making tool. Designed as an Android app, this project showcases how advanced models can simplify complex location assessments. 

---

## 🛠️ Project Overview

This repository includes all resources and code needed for the ANP-CODAS LocationApp, covering everything from APIs and processing formulas to interfaces that enhance the overall user experience.

### 🔑 Key Features
- **📊 Advanced Decision Models:** CODAS and ANP methodologies to optimize location-based evaluations.
- **🎨 User-Friendly Interface:** Intuitive design ensures smooth interactions and a refined experience.
- **🔒 Secure API Integration:** Prioritizes data privacy through secure, encrypted connections.

---

## 📂 Documentation & Diagrams

### 📐 **Data Flow Diagram (DFD)**

A **Data Flow Diagram (DFD)** visually represents how data moves through a system. It maps out the flow from input, processing, storage, and output, helping users understand the system’s structure and interactions.

Below, the DFD provides an overview of this application’s data flow, showcasing how user actions lead to data processing and final outputs within the app.

![2 drawio](https://github.com/user-attachments/assets/f75b4c69-460e-42e6-9b35-cec395d373fe)

🌐 Data Flow Diagram (DFD) Overview
The Data Flow Diagram (DFD) serves as a visual representation of how data flows through the system, illustrating the interactions between users, processes, and data storage. This diagram is vital for understanding the functionalities of a Decision Support System (DSS) that operates based on specific criteria.

🔑 Key Processes Explained
User Registration: New users can join the system by entering their personal information, creating a unique identity within the platform.

Login Functionality: Registered users, including administrators, can access the system by providing their credentials, ensuring secure entry into the application.

Criteria Management: Administrators have the ability to add, modify, or remove criteria essential for evaluations, which play a crucial role in decision-making.

Criteria Calculation: The system processes the established criteria values to compute scores, laying the groundwork for further evaluations.

Adding Alternatives: Users and admins can input various options or alternatives to be assessed, each representing a potential choice in the decision-making process.

Alternative Assessment: The system evaluates each alternative based on the calculated criteria, producing insights into which options align best with the defined standards.

User Data Storage: The system efficiently manages user data, including activity logs and evaluation results, ensuring a comprehensive record of interactions.

📊 Entities Involved
User: Individuals interacting with the system, utilizing its features for their needs.
Admin: Users with elevated permissions, responsible for system management and oversight.
Criteria: Factors taken into account during evaluations, guiding the decision-making process.
Alternatives: The various options available for assessment based on the established criteria.
Criterion Values: Numerical values assigned to each criterion, representing their significance.
Weight Values: Results derived from the computed criterion values, indicating their impact.
Outcome: The final assessment results, highlighting the most suitable alternatives.
🔄 Data Flow Insights
The DFD showcases the dynamic interactions between entities and processes, illustrating how data transitions from one stage to another. For instance, user information flows from the registration phase to user data storage, while criterion values move from the criteria management process to the calculation phase.

📈 Conclusion
This DFD encapsulates the complex yet streamlined operations of a Decision Support System, emphasizing its role in facilitating informed decision-making through objective assessments. By providing a structured overview of how information circulates, the DFD enhances comprehension for both developers and users, paving the way for potential improvements and adaptations in the system.

**Description:**  
This DFD illustrates each step of the app's data movement. Starting from user input, it details how data is processed across different system modules and eventually reaches the end-user as a result. This structured flow allows for efficient and organized handling of data within the application.

--- 

### 📋 Entity-Relationship Diagram (ERD)
Our Entity-Relationship Diagram (ERD) illustrates the database structure, showcasing the connections and interactions between various data entities. This diagram is essential for understanding how location data is organized, ensuring efficient storage and access throughout the system.

![ERD-sidang drawio](https://github.com/user-attachments/assets/9cf41f94-1456-4908-99b4-9e7e94bd1a49)

**Entities Overview:**

- **User:** Represents individuals utilizing the system. Each user entity encompasses attributes such as `id`, `username`, `name`, `password`, and `role`, defining their access and permissions within the application.

- **Criteria:** Encompasses the evaluation standards applied to alternatives. Attributes such as `id`, `code`, `name`, `status`, and associated comparison values categorize the significance of each criterion.

- **Alternative:** Refers to the options available for assessment. Each alternative is characterized by attributes including `id`, `code`, `name`, `address`, and a reference to the associated user, facilitating user-specific evaluations.

- **Evaluation:** Captures the assessment outcomes for each alternative against specified criteria. It consists of attributes such as `id`, `alternative_id`, `criteria_id`, and `score`, enabling comprehensive performance analysis.

- **Results:** Represents the final outcomes derived from evaluations, incorporating attributes like `id`, `user_id`, `alternative_id`, and computed score, providing a succinct summary of assessment performance.

**Relationships:**

- **User to Criteria:** A single user may define multiple criteria, establishing a one-to-many relationship, which enhances flexibility in evaluation.

- **Criteria to Comparison Values:** Each criterion can possess various comparison values, indicating its relative importance in the decision-making process.

- **User to Alternatives:** Users can submit multiple alternatives for consideration, further exemplifying the one-to-many relationship inherent in the system's design.

- **Alternatives to Results:** Each alternative can yield multiple evaluation results, linking back to user assessments and facilitating a detailed performance overview.

**Interpretation:**

This ERD articulates a structured system designed to systematically evaluate alternatives based on predefined criteria. Users can specify relevant standards, score each alternative, and derive comprehensive results that reflect the weighted significance of these criteria. The meticulous organization encapsulated in this diagram not only streamlines the decision-making process but also bolsters the system's clarity, efficiency, and adaptability.

---

### 📱 Application Interface
This section showcases screenshots and brief descriptions of the app's main screens, including:
  - 🗺️ Location Selection: Choose and prioritize locations based on criteria.
  - 📈 Multi-Criteria Analysis: Calculate and rank locations.
  - 📊 Results Visualization: Easily view and interpret analysis outcomes.

---

Feel free to explore, contribute, or ask questions. This repository is a comprehensive resource for those interested in combining decision analysis with practical Android application development. Happy coding! 🎉
