USE [FU-Dev]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UserProfilePhoto]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_UserProfilePhoto]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UserProfile]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_UserProfile]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UpdatePostPhoto]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_UpdatePostPhoto]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UpdateContributorPost]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_UpdateContributorPost]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_Request_Seen_Status]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_Request_Seen_Status]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_COVER_PHOTO]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_COVER_PHOTO]
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_ChangePassword]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UPDATE_ChangePassword]
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_AddPostToPhoto]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_Update_AddPostToPhoto]
GO
/****** Object:  StoredProcedure [dbo].[USP_UNFRIEND_USER]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_UNFRIEND_USER]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_UserIdForResetLink]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_UserIdForResetLink]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SuggestionList]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SuggestionList]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SIGNUPINFO]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SIGNUPINFO]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEE_ALL]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SEE_ALL]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEARCHUSER_POST]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SEARCHUSER_POST]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SearchContact]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SearchContact]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEARCH_USERINFO]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_SEARCH_USERINFO]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_RELATIONSHIP_LIST]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_RELATIONSHIP_LIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_RELATION_CONTENT]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_RELATION_CONTENT]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PROFILEDATA_USER]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PROFILEDATA_USER]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PreloadDataForUser]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PreloadDataForUser]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PRELOAD_COUNTCHAT]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PRELOAD_COUNTCHAT]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforSELECTEDWord]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PostforSELECTEDWord]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforProfileForSelectedUser]    Script Date: 08-Nov-16 5:31:41 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PostforProfileForSelectedUser]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforProfile]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_PostforProfile]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_OptionView]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_OptionView]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ONLY_FRIENDS]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ONLY_FRIENDS]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_NonFriendUser]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_NonFriendUser]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodsList]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_MoodsList]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodMaster]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_MoodMaster]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodForDay]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_MoodForDay]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_LASTMOOD]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_LASTMOOD]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GETUserProfileData]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_GETUserProfileData]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetSentBox]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_GetSentBox]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetInbox]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_GetInbox]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GETEmailForUser]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_GETEmailForUser]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetAnotherUserData]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_GetAnotherUserData]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FRIENDS_LIST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_FRIENDS_LIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FRIENDS_AND_FOLLOW_LIST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_FRIENDS_AND_FOLLOW_LIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FriendRequestList]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_FriendRequestList]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ExpertiseArea]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ExpertiseArea]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsVideoPostWithPaginationASC]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsVideoPostWithPaginationASC]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsVideoPostWithPagination]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsVideoPostWithPagination]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsSelectedPost]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsSelectedPost]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPaginationDummy]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPaginationDummy]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPaginationASC]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPaginationASC]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPagination]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPagination]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPost]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPost]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPhotoPostWithPaginationASC]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPhotoPostWithPaginationASC]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPhotoPostWithPagination]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ContributorsPhotoPostWithPagination]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CONNECTION_SEARCH]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_CONNECTION_SEARCH]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CHATUSERLIST_RECENT]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_CHATUSERLIST_RECENT]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CHAT_FRIENDLIST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_CHAT_FRIENDLIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ALLCONNECTION_DETAILS]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ALLCONNECTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ALL_FOLLOWING]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_SELECT_ALL_FOLLOWING]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_SHAREPOST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_SHAREPOST]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_SendEmail]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_SendEmail]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ResetLinkID]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_ResetLinkID]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_REPLY_MAIL]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_REPLY_MAIL]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_REMOVEPOST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_REMOVEPOST]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_RELATIONSHIP]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_RELATIONSHIP]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_PROFILE_PHOTO]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_PROFILE_PHOTO]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_OR_UPDATE_LIKE_DISLIKE]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_OR_UPDATE_LIKE_DISLIKE]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_MoodsInfo]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_MoodsInfo]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_FRIEND_ORFOLLOWER]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_FRIEND_ORFOLLOWER]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_Follow_UnFollow_Friend]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_Follow_UnFollow_Friend]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CreateNewPost]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_CreateNewPost]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ContributorProfile]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_ContributorProfile]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CHAT_SEEN]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_CHAT_SEEN]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CHAT_COVERSATION]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_CHAT_COVERSATION]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_BANNER_PHOTO]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_BANNER_PHOTO]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ SignUpInfo]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSERT_ SignUpInfo]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSER_RemoveSuggestion]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSER_RemoveSuggestion]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSER_POST_COMMAND]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_INSER_POST_COMMAND]
GO
/****** Object:  StoredProcedure [dbo].[USP_GETLIKELIST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_GETLIKELIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_GETDISLIKELIST]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_GETDISLIKELIST]
GO
/****** Object:  StoredProcedure [dbo].[USP_GET_LoginDetails]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_GET_LoginDetails]
GO
/****** Object:  StoredProcedure [dbo].[USP_GET_COMMENTED_USER]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_GET_COMMENTED_USER]
GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_OR_ADD_FriendRequest]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_DELETE_OR_ADD_FriendRequest]
GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_FriendRequest]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USP_DELETE_FriendRequest]
GO
/****** Object:  StoredProcedure [dbo].[USE_SELECT_USER_DETAIL_FOR_Comment]    Script Date: 08-Nov-16 5:31:42 PM ******/
DROP PROCEDURE [dbo].[USE_SELECT_USER_DETAIL_FOR_Comment]
GO
