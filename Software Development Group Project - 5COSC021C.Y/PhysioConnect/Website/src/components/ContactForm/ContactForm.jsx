import React from "react";
import { useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import { motion } from "framer-motion";
import "./contactform.css";

const schema = yup.object().shape({
  name: yup.string().min(3, "Name must be at least 3 characters").required("Name is required"),
  email: yup.string().email("Invalid email format").required("Email is required"),
  message: yup.string().min(10, "Message must be at least 10 characters").required("Message is required"),
});

const ContactForm = () => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm({
    resolver: yupResolver(schema),
  });

  const onSubmit = async (data) => {
    console.log("Form submitted: ", data);
    alert("Thank you for reaching out! We will get back to you shortly.");
    reset(); // Clear the form after submission
  };

  return (
    <motion.form
      className="contact-form"
      onSubmit={handleSubmit(onSubmit)}

    >
      <h2 className="form-title">Get in Touch</h2>

      {/* Name Input */}
      <div className="form-group">
        <label htmlFor="name">Name</label>
        <input
          type="text"
          id="name"
          {...register("name")}
          placeholder="Enter your name"
        />
        <p className="error-message">{errors.name?.message}</p>
      </div>

      {/* Email Input */}
      <div className="form-group">
        <label htmlFor="email">Email</label>
        <input
          type="email"
          id="email"
          {...register("email")}
          placeholder="Enter your email"
        />
        <p className="error-message">{errors.email?.message}</p>
      </div>

      {/* Message Input */}
      <div className="form-group">
        <label htmlFor="message">Message</label>
        <textarea
          id="message"
          {...register("message")}
          placeholder="Write your message"
          rows="5"
        ></textarea>
        <p className="error-message">{errors.message?.message}</p>
      </div>

      {/* Submit Button */}
      <motion.button
        type="submit"
        className="submit-button"
        disabled={isSubmitting}
      >
        {isSubmitting ? "Sending..." : "Send Message"}
      </motion.button>
    </motion.form>
  );
};

export default ContactForm;
