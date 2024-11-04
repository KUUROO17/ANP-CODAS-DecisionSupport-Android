# 🌍 ANP-CODAS LocationApp Android 📍

🎉 **Welcome to the ANP-CODAS LocationApp Repository!** 🎉  
Dive into a world of **cutting-edge decision-making** with our innovative project that brilliantly fuses **CODAS** (COmbinative Distance-based ASsessment) and **ANP** (Analytic Network Process) methods! This dynamic Android application is designed to empower users by transforming intricate location evaluations into seamless and intuitive experiences.  

✨ Here, you’ll discover how advanced analytical models can revolutionize the way we approach multi-criteria decision-making, making complex assessments not only manageable but also enjoyable! 🌟  

Join us in exploring the potential of this powerful tool and how it can enhance your decision-making processes. Your adventure in **location assessment** starts here!

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

### 🌐 Data Flow Diagram (DFD) Overview

The **Data Flow Diagram** (DFD) provides a visual representation of the movement of data within the system, illustrating the interactions between users, processes, and data storage. This diagram is essential for understanding the functionalities of a Decision Support System (DSS) that operates based on specific criteria.

#### Key Processes:
- **User Registration:** New users can join the system by entering their personal information, creating a unique identity within the platform.
  
- **Login Functionality:** Registered users, including administrators, can securely access the system by providing their credentials, ensuring safe entry into the application.

- **Criteria Management:** Administrators have the ability to add, modify, or remove criteria that are essential for evaluations, which play a crucial role in decision-making.

- **Criteria Calculation:** The system processes established criteria values to compute scores, laying the groundwork for further evaluations.

- **Adding Alternatives:** Users and administrators can input various options or alternatives for assessment, each representing a potential choice in the decision-making process.

- **Alternative Assessment:** The system evaluates each alternative based on the calculated criteria, producing insights into which options align best with the defined standards.

- **User Data Storage:** The system efficiently manages user data, including activity logs and evaluation results, ensuring a comprehensive record of interactions.

### 📊 Entities Involved

- **User:** Represents individuals utilizing the system. Each user entity encompasses attributes such as `id`, `username`, `name`, `password`, and `role`, defining their access and permissions within the application.

- **Admin:** A user with elevated permissions, responsible for managing the system and overseeing operations.

- **Criteria:** Factors taken into account during evaluations, guiding the decision-making process, with attributes including `id`, `code`, `name`, and `status`.

- **Alternatives:** Various options available for assessment based on established criteria, which may include attributes like `id`, `code`, `name`, and `address`.

- **Criterion Values:** Numerical values assigned to each criterion, representing their significance in the evaluation process.

- **Weight Values:** Results derived from computed criterion values, indicating the impact of each criterion on the overall assessment.

- **Outcome:** The final assessment results that highlight the most suitable alternatives based on user-defined criteria.

### 🔄 Data Flow Insights

The DFD showcases the dynamic interactions between entities and processes, illustrating how data transitions from one stage to another. For instance, user information flows from the registration phase to user data storage, while criterion values move from the criteria management process to the calculation phase.

### 📈 Conclusion

This DFD encapsulates the complex yet streamlined operations of a Decision Support System, emphasizing its role in facilitating informed decision-making through objective assessments. By providing a structured overview of how information circulates, the DFD enhances comprehension for both developers and users, paving the way for potential improvements and adaptations in the system.

**Description:**  
This DFD illustrates each step of the app's data movement. Starting from user input, it details how data is processed across different system modules and eventually reaches the end user as a result. This structured flow allows for efficient and organized handling of data within the application.

--- 

### 📋 Entity-Relationship Diagram (ERD)

Our Entity-Relationship Diagram (ERD) illustrates the database structure, showcasing the connections and interactions between various data entities. This diagram is essential for understanding how location data is organized, ensuring efficient storage and access throughout the system.

![ERD-sidang drawio](https://github.com/user-attachments/assets/9cf41f94-1456-4908-99b4-9e7e94bd1a49)

#### Entities Overview:

- **User:** Represents individuals utilizing the system. Each user entity encompasses attributes such as `id`, `username`, `name`, `password`, and `role`, defining their access and permissions within the application.

- **Criteria:** Encompasses the evaluation standards applied to alternatives. Attributes such as `id`, `code`, `name`, `status`, and associated comparison values categorize the significance of each criterion.

- **Alternative:** Refers to the options available for assessment. Each alternative is characterized by attributes including `id`, `code`, `name`, `address`, and a reference to the associated user, facilitating user-specific evaluations.

- **Evaluation:** Captures the assessment outcomes for each alternative against specified criteria. It consists of attributes such as `id`, `alternative_id`, `criteria_id`, and `score`, enabling comprehensive performance analysis.

- **Results:** Represents the final outcomes derived from evaluations, incorporating attributes like `id`, `user_id`, `alternative_id`, and computed score, providing a succinct summary of assessment performance.

#### Relationships:

- **User to Criteria:** A single user may define multiple criteria, establishing a one-to-many relationship, which enhances flexibility in evaluation.

- **Criteria to Comparison Values:** Each criterion can possess various comparison values, indicating its relative importance in the decision-making process.

- **User to Alternatives:** Users can submit multiple alternatives for consideration, further exemplifying the one-to-many relationship inherent in the system's design.

- **Alternatives to Results:** Each alternative can yield multiple evaluation results, linking back to user assessments and facilitating a detailed performance overview.

### **Interpretation:**

This ERD articulates a structured system designed to systematically evaluate alternatives based on predefined criteria. Users can specify relevant standards, score each alternative, and derive comprehensive results that reflect the weighted significance of these criteria. The meticulous organization encapsulated in this diagram not only streamlines the decision-making process but also bolsters the system's clarity, efficiency, and adaptability.

---

### 📱 Application Interface

This section highlights the pivotal screens of the application, providing a detailed look into both the Admin and User interfaces through engaging descriptions and screenshots. 

#### 🔐 Admin Interface

The **Admin Interface** is a pivotal component of the application, designed to equip administrators with the necessary tools to efficiently manage system functionalities and optimize decision-making processes. This section features two critical screens:

- 🔑 **Admin Login:**  
  The entry point for administrators, this secure login screen ensures that only authorized personnel can access the management features of the application. It lays the groundwork for maintaining system integrity and data confidentiality.
  
  ![image](https://github.com/user-attachments/assets/ae40c20d-a075-4958-a280-2237daa8224b)

- 📝 **Criteria Management & Evaluation:**  
  This dynamic screen enables administrators to effortlessly add new criteria and assess existing ones. Administrators can input comparative values assigned to each criterion, derived from expert evaluations and interviews, ensuring the criteria reflect informed insights. The application utilizes the Analytic Network Process (ANP) method to compute the results, displaying the rankings and analyses clearly, thus facilitating strategic decision-making.
  
  ![image](https://github.com/user-attachments/assets/9964356f-1981-4563-948d-21c7290dc0a8)

With its user-friendly design and powerful functionalities, the Admin Interface not only streamlines the management of criteria but also enhances the overall effectiveness of the decision support system.

---

#### 🧑‍🤝‍🧑 User Interface

The **User Interface** is designed to provide a seamless and engaging experience for users, ensuring easy navigation and efficient management of alternatives. Here’s an overview of its key features:

- **CRUD for Alternatives 🛠️:** This section offers users a comprehensive platform to manage alternatives effortlessly. Users can add new options, edit existing entries, and navigate directly to the **Alternative Assessment** page. With its intuitive layout, users can maintain an organized view of all alternatives, enhancing the overall management process.
    
  ![image](https://github.com/user-attachments/assets/9dd49f94-3430-4d13-83af-69a8b78dc915)

- **Alternative Calculations & Results 📊:**  
  Users can efficiently analyze alternatives based on established criteria and view results in a visually appealing format. This functionality is crucial for ensuring informed decision-making, as users can quickly assess which alternatives align best with their criteria. The clarity of the displayed results fosters confidence in the decision-making process.

  ![image](https://github.com/user-attachments/assets/bbc605b3-dab6-498a-b312-a6a7f60fd2f7)

By emphasizing user experience and accessibility, the User Interface promotes engagement and effectiveness in managing alternatives, ultimately enhancing the overall functionality of the ANP-CODAS LocationApp.

---

## 🚀 Getting Started

To start using the ANP-CODAS LocationApp, follow these simple steps:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/ANP-CODAS-LocationApp-Android.git
   ```
2. **Open the project in Android Studio.**
3. **Build and run the application on your preferred device.**

---

### 🎉🎊 Conclusion 🎊🎉

In conclusion, this project beautifully merges the principles of decision analysis with the dynamic world of Android application development! 🚀✨ The application is designed to empower both administrators and users, providing them with a seamless experience in managing alternatives and conducting thorough evaluations based on carefully defined criteria. 

With its vibrant interface and robust features, navigating through user registration, criteria management, and alternative assessment becomes a breeze! 🌟 Users can effortlessly engage in a comprehensive decision-making journey that is both effective and enjoyable. 

We invite you to dive into this repository, explore its functionalities, contribute your insights, or ask any questions you may have! 💬🤗 This is not just a project; it's a collaborative resource for anyone passionate about blending decision analysis with innovative Android application development. 

Happy coding, and let the adventure begin! 🎉🚀💻
