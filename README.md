# BJIT DevOps Task 🚀

Welcome to the BJIT DevOps Task repository! This project demonstrates a simple web application with a DevOps focus, including infrastructure provisioning using Terraform on AWS. 🌐

## Table of Contents 📋

- [Overview](#overview)
- [Backend](#backend)
- [Frontend](#frontend)
- [Continuous Integration/Deployment](#continuous-integrationdeployment)
- [Networking](#networking)
- [Terraform Configuration](#terraform-configuration)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Overview 📝

This repository showcases the implementation of various components:

1. **Backend**:
   - Two API Servers (API Server, File Service)
   - Autoscaling for one of the API servers
   - RDS (Relational Database Service)
   - Redis Server
   - SSL certificate and domain configuration

2. **Frontend**:
   - Amazon CloudFront for the frontend
   - Access restriction strategy

3. **Continuous Integration/Deployment**:
   - Diagram and options for CI/CD

4. **Networking**:
   - VPC configuration using Terraform

## Backend ⚙️

The backend of this application consists of two Python Flask-based servers: the API Server and the File Server. The frontend communicates with the API Server, which in turn interacts with the File Server to manage file operations, enhancing security and control.

Additional components include RDS and Redis servers, as well as SSL certificate and domain configuration.

## Frontend 🖥️

The frontend of this application utilizes basic HTML, CSS, and JavaScript. Amazon CloudFront is implemented for content delivery, and access to the frontend is restricted to ensure security.

## Continuous Integration/Deployment 🚀

This project includes options for CI/CD, ensuring automated and streamlined development workflows.

## Networking 🌐

The networking components are configured using Terraform and include VPC, subnets, security groups, route tables, and more.

## Terraform Configuration 🛠️

The Terraform code used to provision the infrastructure can be found in the `terraform` directory of this repository.

## Getting Started 🚀

Will add later on

## License 📄

This project is licensed under the [MIT License](LICENSE).

Feel free to explore the code and use it as a reference for your own DevOps tasks! If you have any questions or need assistance, please don't hesitate to reach out.

Happy DevOps-ing! 🎉
