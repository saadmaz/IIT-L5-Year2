import React from "react";
import { FaUserPlus, FaBullseye, FaHandsHelping, FaChartLine, FaUserMd, FaTrophy } from "react-icons/fa";

export const steps = [
    {
        title: "Sign Up & Add Health Records",
        description: "Create an account and provide previous health records for better recommendations.",
        icon: <FaUserPlus />,
    },
    {
        title: "Choose Pain Points",
        description: "Select areas where you feel discomfort to receive tailored recovery plans.",
        icon: <FaBullseye />,
    },
    {
        title: "Get Customized Remedies",
        description: "Receive step-by-step tutorials and personalized DIY physiotherapy aids.",
        icon: <FaHandsHelping />,
    },
    {
        title: "Monitor & Track Recovery",
        description: "Log your pain levels and track your progress over time.",
        icon: <FaChartLine />,
    },
    {
        title: "Connect with Physiotherapists",
        description: "If necessary, consult with physiotherapists for professional guidance.",
        icon: <FaUserMd />,
    },
    {
        title: "Use Gamification for Perks",
        description: "Unlock premium features by engaging in daily exercises and challenges.",
        icon: <FaTrophy />,
    },
];
