//
//  Constants.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/19/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
/* URL */
//https://xpowerwebapi20200430054944.azurewebsites.net/api/Point/GetUserProgress?Username=san

let BASE_URL = "https://xpowerwebapi20200430054944.azurewebsites.net/api/"
let USER_SERVICE_URL = "User/"
let POINT_SERVICE_URL = "Point/"
let CHAT_SERVICE_URL = "Chat/"

let AUTHENTICATION_PATH = "UserAuthentication"
let CREATE_ACCOUNT = "CreateUserAccount"
let RESET_PASSWORD = "resetpassword"
let POINTS_TABLE = "PointsTable"
let GET_FAVORITE_TASK = "GetFavoriteTask"
let SET_FAVORITE_TASK = "SetFavoriteTask"
let ADD_DEEDS = "Adddeeds"
let RECENT_DEEDS = "GetRecentDeeds"
let SCHOOL_POINTS = "TotalSchoolPoints"
let GET_FRIEND_LIST = "GetFriendList"
let GET_FRIEND_REQUEST_LIST = "GetFriendRequests"
let RESPOND_TO_REQUEST = "RespondFriendRequest"
let ADD_FRIEND_REQUEST = "AddFriendRequest"
let CHANGE_PASSWORD = "ChangePassword"
let TOGGLE_TOUCH_ID = "ToggleTouchId"
let GET_MESSAGES = "GetMessage"
let SEND_MESSAGE = "SendMessage"
let GET_USER_PROGRESS = "GetUserProgress?Username="
let GET_DAILY_POINTS = "GetDailyPoint?Username="
let GET_TOTAL_SCHOOL_POINTS = "TotalSchoolPoints?Schoolname="


let APP_NAME = "XPower"


/*
 LOGIN/SIGNUP KEYS
 */
let USER_NAME = "Username"
let PASSWORD = "Password"
let EMAIL = "Email"
let SCHOOL_NAME = "SchoolName"
let AVATAR = "Avatar"
let AVATAR_IMG_URL = "Avatarimageurl"
let TOUCH_ID_ON = "TouchIdOn"
let FORGET_PASSWORD = "Forgot Password"
let USER_IMG_AVATAR = "UserImageAvatar"
let ACTION_SUBMIT = "Submit"
let ACTION_REQUIRED = "Required"
let ACTION_OK = "Ok"
let ACTION_SIGNUP = "Sign Up"


let MSG_SUCCESS = "Success"
let LOGIN_NO_EMPTY_ALLOWED = "username and password cannot be left empty"
let SIGNUP_NO_EMPTY_ALLOWED = "All Fields are required"

let LOGIN_SUCCESS = "Login Successfull"

let EMAIL_PLACEHOLDER = "Please enter your Email Address"
let SELECT_SCHOOL = "Select School"


let SCHOOL_HAVERFORD = "Haverford"
let MAIL_HAVERFORD = "@haverford.org"

let SCHOOL_AGNES_IRWIN = "Agnes Irwin"
let MAIL_AGNES_IRWIN = "@agnesirwin.org"

let SEARCH_DEEDS_PLACEHOLDER = "Search Deeds"

let SETTINGS_CHANGE_PASSWORD = "Change Password"
let SETTINGS_REPORT = "Report"
let MAIL_NOT_ALLOWED = "The App does not have permission to open mail. Try configuring mail box"

enum menu:String
{
    case home = "Home",points = "Points",score = "Score",friends = "Friends",settings = "Settings",logout = "Logout"
}

// Notification
let NOTIFICATION_TITLE_MESSAGE = "New Message"
let NOTIFICATION_TITLE_REQUEST = "New Friend Request"














