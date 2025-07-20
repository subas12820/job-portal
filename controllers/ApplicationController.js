const Application = require("../models/Application")
const Job = require("../models/Job")
const { validationResult } = require("express-validator")

class ApplicationController {
  static async apply(req, res) {
    try {
      const errors = validationResult(req)

      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          errors: errors.array(),
        })
      }

      const job = await Job.findById(req.params.jobId)

      if (!job) {
        return res.status(404).json({
          success: false,
          message: "Job not found",
        })
      }

      const existingApplication = await Application.findByJobAndApplicant(req.params.jobId, req.user.id)

      if (existingApplication) {
        return res.status(400).json({
          success: false,
          message: "You have already applied for this job",
        })
      }

      const applicationData = {
        job_id: req.params.jobId,
        applicant_id: req.user.id,
        cover_letter: req.body.cover_letter,
      }

      await Application.create(applicationData)

      res.json({
        success: true,
        message: "Application submitted successfully!",
      })
    } catch (error) {
      console.error("Application error:", error)
      res.status(500).json({
        success: false,
        message: "Failed to submit application",
      })
    }
  }

  static async myApplications(req, res) {
    try {
      const applications = await Application.findByApplicantId(req.user.id)

      res.render("applications/my-applications", {
        title: "My Applications",
        user: req.user,
        applications,
      })
    } catch (error) {
      console.error("My applications error:", error)
      res.render("applications/my-applications", {
        title: "My Applications",
        user: req.user,
        applications: [],
      })
    }
  }

  static async updateStatus(req, res) {
    try {
      const { status } = req.body
      const applicationId = req.params.id

      const applications = await Application.findByCompanyId(req.user.id)
      const application = applications.find((app) => app.id == applicationId)

      if (!application) {
        return res.status(404).json({
          success: false,
          message: "Application not found",
        })
      }

      await Application.updateStatus(applicationId, status)

      res.json({
        success: true,
        message: "Application status updated successfully",
      })
    } catch (error) {
      console.error("Update status error:", error)
      res.status(500).json({
        success: false,
        message: "Failed to update application status",
      })
    }
  }
}

module.exports = ApplicationController
