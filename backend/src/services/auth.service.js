import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'
import nodemailer from 'nodemailer'

// Send the reset password email
const transporter = nodemailer.createTransport({
  // Configure your email service provider here
  host: 'smtp.titan.email',
  port: 465,
  secure: true,
  auth: {
    user: process.env.EMAIL,
    pass: process.env.EMAIL_PASSWORD,
  },
})

async function sendAuthEmail(mailOptions, res) {
  try {
    const info = await transporter.sendMail(mailOptions)
    return info
  } catch (error) {
    console.log('error sending email', error)
    return res.status(400).json({ message: 'Error sending email', error })
  }
}

// hashing password
const hashingPassword = async ({ password }) => {
  const salt = await bcrypt.genSalt(10)
  const hashedPassword = await bcrypt.hash(password, salt)
  return hashedPassword
}

// verify password
const verifyPassword = async ({ commingPassword, usersPassword }) => {
  const validPassword = await bcrypt.compare(commingPassword, usersPassword)
  return validPassword
}

// assigning token
const assignToken = ({ id }) => jwt.sign({ id }, process.env.TOKEN_SECRET)

// generate unique 4 digit number
function generateOTP() {
  // Generate a random 4-digit number
  const randomNum = Math.floor(1000 + Math.random() * 9000).toString()

  // Add current milliseconds to further ensure uniqueness
  const timeComponent = new Date().getMilliseconds().toString()

  // Concatenate both parts and slice to get the last 4 digits
  const otp = (randomNum + timeComponent).slice(0, 4)

  return otp
}

export {
  hashingPassword,
  assignToken,
  verifyPassword,
  sendAuthEmail,
  generateOTP,
}
