import React from "react";
import { FaCrown, FaCode, FaRocket, FaPaintBrush, FaMoneyBillWave } from "react-icons/fa";

export const teamMembers = [
    {
        name: "Himaza Zahara",
        role: "CEO (Chief Executive Officer)",
        secondaryRole: "Head of Strategy & Vision",
        icon: <FaCrown className="team-icon" />,
        image: "/assets/Himaza.png",
    },
    {
        name: "Sachira Delankawala",
        role: "CMO (Chief Marketing Officer)",
        secondaryRole: "Lead Frontend Engineer",
        icon: <FaPaintBrush className="team-icon" />,
        image: "/assets/Sachira.png",
    },
    {
        name: "Saad Mazhar",
        role: "COO (Chief Operations Officer)",
        secondaryRole: "Lead of Project Operations",
        icon: <FaCode className="team-icon" />,
        image: "/assets/Saad.png",
    },
    {
        name: "Thejan Paranagama",
        role: "CTO (Chief Technology Officer)",
        secondaryRole: "Lead Backend Engineer",
        icon: <FaCode className="team-icon" />,
        image: "/assets/Thejan.png",
    },
    {
        name: "Azeezur Rahmaan",
        role: "CIO (Chief Innovation Officer)",
        secondaryRole: "Lead AI & Data Science Incharge",
        icon: <FaRocket className="team-icon" />,
        image: "/assets/Azeez.png",
    },
    {
        name: "Sathnara Perera",
        role: "CQA (Chief Quality Officer)",
        secondaryRole: "Lead QA Incharge",
        icon: <FaMoneyBillWave className="team-icon" />,
        image: "/assets/Sathnara.png",
    },
];
