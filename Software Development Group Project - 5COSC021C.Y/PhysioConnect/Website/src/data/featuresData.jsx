import React from "react";
import {
    FaUserMd, FaVideo, FaChartLine, FaBookOpen, FaUserShield,
    FaBrain, FaDumbbell, FaMedkit, FaHospitalAlt, FaRobot, FaMapMarkerAlt, FaBell, FaTabletAlt
} from "react-icons/fa";
import { MdHealthAndSafety, MdOutlineHealthAndSafety } from "react-icons/md";
import { GiBodySwapping } from "react-icons/gi";
import { AiOutlineMessage } from "react-icons/ai";

export const features = {
    "Core Features": [
        { title: "Interactive 2D Model", description: "Select pain areas and receive treatment recommendations.", icon: <GiBodySwapping /> },
        { title: "Customized Injury Remedies", description: "Get tailored exercises and at-home treatment plans.", icon: <FaUserMd /> },
        { title: "First Aid Tutorials", description: "Step-by-step guidance on injury management.", icon: <FaMedkit /> },
        { title: "User Profile & Injury History", description: "Track your recovery and view past injuries.", icon: <FaUserShield /> },
    ],
    "Health Monitoring": [
        { title: "Notifications & Reminders", description: "Daily health tips and recovery reminders.", icon: <FaBell /> },
        { title: "Pain Monitoring", description: "Track pain levels over time for better treatment.", icon: <FaBrain /> },
        { title: "Progress Tracking", description: "Monitor improvements in flexibility and pain levels.", icon: <FaChartLine /> },
    ],
    "Consultation & AI Support": [
        { title: "AR Implementation", description: "Augmented Reality guidance for exercises.", icon: <MdHealthAndSafety /> },
        { title: "Video Consultations", description: "Connect with physiotherapists remotely.", icon: <FaVideo /> },
        { title: "AI Chatbot for Physiotherapy Advice", description: "Get instant AI-driven recovery recommendations.", icon: <FaRobot /> },
        { title: "In-app Messaging", description: "Chat with physiotherapists for instant guidance.", icon: <AiOutlineMessage /> },
    ],
    "Additional Resources": [
        { title: "Educational Resources", description: "Access a library of physiotherapy knowledge.", icon: <FaBookOpen /> },
        { title: "Customizable Exercise Plans", description: "Personalized exercise routines based on recovery needs.", icon: <FaDumbbell /> },
        { title: "Gamification", description: "Earn rewards and track progress with interactive challenges.", icon: <MdOutlineHealthAndSafety /> },
        { title: "Electronic Personal Health Record", description: "Store medical history and treatment details.", icon: <FaTabletAlt /> },
        { title: "Nearby Facilities Locator", description: "Find nearby physiotherapy centers and pharmacies.", icon: <FaMapMarkerAlt /> },
        { title: "One-Tap Emergency Contacts", description: "Instantly connect with emergency contacts.", icon: <FaHospitalAlt /> },
    ],
};
