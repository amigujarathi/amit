USE [FU-Dev]
GO
/****** Object:  StoredProcedure [dbo].[USE_SELECT_USER_DETAIL_FOR_Comment]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USE_SELECT_USER_DETAIL_FOR_Comment] 
	-- Add the parameters for the stored procedure here
	@POSTID BIGINT,
	@USERID BIGINT,
	@StartIndex INT,
	@EndIndex INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	;WITH GetComment AS(
	SELECT ROW_NUMBER() OVER 
	(ORDER BY COMMENT_DATE_TIME ASC,COMMENTS_ID ASC) AS ID,COMMENTS_ID,
	COMMENTS_TEXT,
	COMMENTS_USER_ID,
	POST_ID,
	UP.FIRST_NAME,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO
	FROM [dbo].[USER_POSTS_COMMENTS] UPC
	INNER JOIN USER_PROFILE UP ON UP.USER_ID=UPC.COMMENTS_USER_ID
	WHERE POST_ID=@POSTID
	)

	SELECT * FROM GetComment WHERE ID 
	BETWEEN @StartIndex AND @EndIndex

END

GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_FriendRequest]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_DELETE_FriendRequest]
	-- Add the parameters for the stored procedure here
	@p_var_MainUserSignupID BIGINT,
	@p_var_UserSignupID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_var_MainUserID BIGINT,
	@p_var_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT @p_var_MainUserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_MainUserSignupID


	SELECT @p_var_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_UserSignupID

	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_STATUS=2 
	WHERE RECEIVEDBY_USER_ID=@p_var_MainUserID
	AND SENTBY_USER_ID=@p_var_UserID
	SELECT 1 AS STATUS

END

GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_OR_ADD_FriendRequest]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_DELETE_OR_ADD_FriendRequest]
	-- Add the parameters for the stored procedure here
	@p_var_MainUserSignupID BIGINT,
	@p_var_UserSignupID BIGINT,
	@p_var_Flag INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_var_MainUserID BIGINT,
	@p_var_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT @p_var_MainUserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_MainUserSignupID

	-------Flag @p_var_UserID=2 for delete and 1 for add

	SELECT @p_var_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_UserSignupID

	IF @p_var_Flag= 2  ------------Delete
	BEGIN


	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_STATUS=2 
	WHERE RECEIVEDBY_USER_ID=@p_var_MainUserID
	AND SENTBY_USER_ID=@p_var_UserID
	SELECT 1 AS STATUS

	END
	ELSE  ------------Add 
	BEGIN
		print('b');
	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_STATUS=1 
	WHERE RECEIVEDBY_USER_ID=@p_var_MainUserID
	AND SENTBY_USER_ID=@p_var_UserID
	SELECT 1 AS STATUS

	END

	select @p_var_MainUserID as sent ,@p_var_UserID as rec,@p_var_Flag

END


GO
/****** Object:  StoredProcedure [dbo].[USP_GET_COMMENTED_USER]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GET_COMMENTED_USER]
	-- Add the parameters for the stored procedure here
	@POST_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT UP.USER_ID,UP.FIRST_NAME,UP.LAST_NAME  FROM [dbo].[USER_POSTS_COMMENTS] UPC
	INNER JOIN USER_PROFILE UP ON UP.USER_ID=UPC.COMMENTS_USER_ID
	WHERE POST_ID=@POST_ID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_GET_LoginDetails]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GET_LoginDetails] 
	-- Add the parameters for the stored procedure here
	@p_var_UserName varchar(15),
	@p_var_Password varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
	 
	 IF NOT EXISTS (	SELECT DISTINCT	UP.USER_ID,
					UP.SIGNUP_ID,
					ROLE_NAME,
					UP.ROLE_ID,
					UP.USER_NAME
					FROM USER_PROFILE UP join 
					ROLE_MASTER RM on RM.ROLE_ID=UP.ROLE_ID RIGHT JOIN
					FORGOT_PWD FP ON UP.USER_ID=FP.USER_ID
					INNER JOIN SIGNUP_INFO SI ON  UP.SIGNUP_ID =SI.ID 
					WHERE (UP.USER_NAME = @p_var_UserName OR SI.SIGNUP_EMAIL = @p_var_UserName) AND FP.IS_LINK_ACTIVE = 1 AND	
					UP.USER_PWD = @p_var_Password  COLLATE SQL_Latin1_General_CP1_CS_AS)
			BEGIN
				SELECT	1 AS STATUS,
						UP.USER_ID,
						UP.SIGNUP_ID,
						ROLE_NAME,
						UP.ROLE_ID,
						UP.USER_NAME
						FROM USER_PROFILE UP join ROLE_MASTER RM on RM.ROLE_ID=UP.ROLE_ID 
						INNER JOIN SIGNUP_INFO SI ON  UP.SIGNUP_ID =SI.ID 
						
						WHERE	(UP.USER_NAME = @p_var_UserName OR SI.SIGNUP_EMAIL =@p_var_UserName)
						AND	UP.USER_PWD = @p_var_Password  COLLATE SQL_Latin1_General_CP1_CS_AS
				END 
	  ELSE
				 SELECT	0 AS STATUS
						
	END TRY
	BEGIN CATCH
		SELECT	ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[USP_GETDISLIKELIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GETDISLIKELIST] 
	-- Add the parameters for the stored procedure here
	@POSTID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @LIKECOUNT INT 
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		select  DISTINCT TOP 10 UP.USER_ID,UP.FIRST_NAME,

		UP.LAST_NAME,UP.PROFILE_PHOTO 

		from [dbo].[USER_POSTS_DISLIKE] UPL

		INNER JOIN USER_PROFILE UP ON 

		UP.USER_ID=UPL.DISLIKE_USER_ID

		WHERE UPL.POST_ID=@POSTID



END

GO
/****** Object:  StoredProcedure [dbo].[USP_GETLIKELIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GETLIKELIST] 
	-- Add the parameters for the stored procedure here
	@POSTID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @LIKECOUNT INT 
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		select  DISTINCT TOP 10 UP.USER_ID,UP.FIRST_NAME,

		UP.LAST_NAME,UP.PROFILE_PHOTO 

		from [dbo].[USER_POSTS_LIKE] UPL

		INNER JOIN USER_PROFILE UP ON 

		UP.USER_ID=UPL.LIKE_USER_ID

		WHERE UPL.POST_ID=@POSTID



END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSER_POST_COMMAND]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSER_POST_COMMAND]
	-- Add the parameters for the stored procedure here
	@POST_USERID BIGINT,
	@POST_ID BIGINT,
	@COMMENTS_USERID BIGINT,
	@COMMENT_TEXT VARCHAR(700)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	INSERT INTO [dbo].[USER_POSTS_COMMENTS] 
	(USER_ID,POST_ID,COMMENTS_USER_ID,COMMENTS_TEXT,COMMENT_DATE_TIME)
	VALUES(@POST_USERID,@POST_ID,@COMMENTS_USERID,@COMMENT_TEXT,GETDATE());

	SELECT COUNT(*) AS COMMENTCOUNT
	FROM [dbo].[USER_POSTS_COMMENTS] WHERE POST_ID=@POST_ID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSER_RemoveSuggestion]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSER_RemoveSuggestion]
	-- Add the parameters for the stored procedure here
	@SignUP_ID BIGINT,
	@REMOVE_SignUP_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @USERID BIGINT,
	@REMOVE_USERID BIGINT
	SET NOCOUNT ON;

	SELECT @USERID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @SignUP_ID

	SELECT @REMOVE_USERID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @REMOVE_SignUP_ID
    -- Insert statements for procedure here
	INSERT INTO [dbo].[USER_SUGGESTION_REMOVE] (USER_ID, REMOVE_USER_ID) 
	VALUES(@USERID,@REMOVE_USERID)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ SignUpInfo]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_INSERT_ SignUpInfo]
      @p_var_SignUpName varchar(100),
      @p_var_SignUpEmail VARCHAR(100)
AS
BEGIN

DECLARE 
	@var_IsuserPresent int,
	@var_ID int
     BEGIN TRY
				IF EXISTS(SELECT ID FROM SIGNUP_INFO WHERE SIGNUP_EMAIL=@p_var_SignUpEmail)
					BEGIN
					UPDATE [dbo].[SIGNUP_INFO] SET SIGNUP_NAME=@p_var_SignUpName WHERE SIGNUP_EMAIL=@p_var_SignUpEmail
					SELECT @var_ID=ID FROM [dbo].[SIGNUP_INFO] WHERE SIGNUP_EMAIL=@p_var_SignUpEmail
					SELECT @var_IsuserPresent=COUNT(*) FROM USER_PROFILE WHERE SIGNUP_ID=@var_ID
					SELECT @var_ID as ID,1 AS Status,@var_IsuserPresent AS IsPresent;
					END 
				ELSE
					BEGIN
					INSERT INTO [dbo].[SIGNUP_INFO](SIGNUP_NAME,SIGNUP_EMAIL) values(@p_var_SignUpName,@p_var_SignUpEmail);
					SELECT @@IDENTITY as ID,0 As Status,0 AS IsPresent;
					END

	END TRY
	BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH  
     
END

--select * from USER_PROFILE

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_BANNER_PHOTO]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: <Create Date,,>
-- Description:	insert cover photo
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_BANNER_PHOTO]
	@p_signup_id int,
	@p_profile_cover varchar(300)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE USER_PROFILE SET USER_COVER_PHOTO = @p_profile_cover WHERE SIGNUP_ID = @p_signup_id
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CHAT_COVERSATION]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam 
-- Create date: 19-oct-2016
-- Description:	to insert message for user 
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_CHAT_COVERSATION]
	-- Add the parameters for the stored procedure here
	@p_var_SenderSignUpID BiGINT,
	@p_var_ReceiverSignUpID BiGINT,
	@p_var_Message varchar(MAX)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 
	@Sender_UserID BIGINT,
	@Receiver_SignUpId BIGINT

    SELECT @Sender_UserID=USER_ID FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SenderSignUpID

	SELECT @Receiver_SignUpId=USER_ID FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_ReceiverSignUpID

    -- Insert statements for procedure here
	
	INSERT INTO dbo.USER_CHATS (FROM_USER_ID,TO_USER_ID,CHAT_MESSAGE,CHAT_DATE)
	VALUES(@Sender_UserID,@Receiver_SignUpId,@p_var_Message,GETDATE())
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CHAT_SEEN]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 22-OCT-16
-- Description:	To set the chat seen count
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_CHAT_SEEN]
	-- Add the parameters for the stored procedure here
	@p_signup_id int
AS
DECLARE 
@p_UserID int

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE SIGNUP_ID = @p_signup_id
    -- Insert statements for procedure here
	
	UPDATE USER_CHATS SET IS_SEEN =1 
	WHERE TO_USER_ID= @p_UserID
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ContributorProfile]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 19-sept-2016
-- Description:	to save the information of new user either organization or indual user.
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_ContributorProfile] 
	-- Add the parameters for the stored procedure here
	@p_var_Signup_ID BIGINT,
	@p_var_Password VARCHAR(50),
	@p_var_UserTypeID TINYINT,
	@p_var_UserName VARCHAR(50),
	@p_var_RoleId INT,
	@p_organization_name  VARCHAR(50),
	@p_first_Name VARCHAR(50),
	@p_Last_Name VARCHAR(50),
    @p_Email VARCHAR(50)
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE 
	
	@var_ID BIGINT,
	@p_var_Count INT,
    @p_var_Ucount INT
	--@p_var_EmailCount INT
	
     BEGIN TRY

		
				SELECT @p_var_Count=COUNT(*) FROM  USER_PROFILE WHERE USER_NAME=@p_var_UserName
				SELECT @p_var_Ucount=COUNT(*) FROM  USER_PROFILE WHERE SIGNUP_ID=@p_var_Signup_ID
				--SELECT @p_var_EmailCount =COUNT(*) FROM SIGNUP_INFO WHERE SIGNUP_EMAIL =@p_Email
				
			IF @p_var_Ucount<1
					BEGIN
			IF @p_var_Count<1
					BEGIN
			
			--IF 	@p_var_EmailCount >1
			--BEGIN	
						--INSERT INTO Email SIGNUP_INFO TABLE
						UPDATE  SIGNUP_INFO SET SIGNUP_EMAIL =@p_Email WHERE ID = @p_var_Signup_ID
					
						INSERT INTO USER_PROFILE (SIGNUP_ID,USERTYPE_ID,ROLE_ID,USER_NAME,USER_PWD,CREATED_DATE,FIRST_NAME,LAST_NAME,ORGANIZATION_NAME)
						VALUES(@p_var_Signup_ID,@p_var_UserTypeID,@p_var_RoleId,@p_var_UserName,@p_var_Password,GETDATE(),@p_first_Name,@p_Last_Name,@p_organization_name)

						SELECT @@IDENTITY as ID,0 AS COUNT
					END
			ELSE
					BEGIN
					SELECT 0 as ID,1 AS COUNT
					END
					END
			ELSE
					BEGIN
					SELECT USER_ID AS ID,0 AS COUNT FROM  USER_PROFILE WHERE SIGNUP_ID=@p_var_Signup_ID
					END
					 --END
		   --ELSE 
		   --BEGIN
		   --SELECT 0 as ID,2 AS COUNT
		   --END
		   
		   			
	END TRY
	BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH  
END



GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_CreateNewPost]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_CreateNewPost]
	-- Add the parameters for the stored procedure here
	@p_var_UserId BIGINT,
	@p_var_PostDate DATE,
	@p_var_PhotoUrl varchar(200),
	@p_var_VideoUrl varchar(200),
	--@p_var_PostHeadLine1 varchar(40),
	@p_var_PostHeadLine2 varchar(MAX),
	@p_var_PostWebLink varchar(300),
	@p_var_PostViewOptionId int,
	@p_var_PostTag varchar(100),
	@p_var_PostExpertise varchar(100),
	@p_var_PostMood varchar(100),
	@p_var_Hasphoto bit,
	@p_var_Hasvideo bit,
	@p_var_Ispublish bit,
	@p_var_PostData varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @Post_ID BIGINT,
		 @USERID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 BEGIN TRY

				SELECT @USERID=USER_ID 
				FROM  [DBO].[USER_PROFILE]
				WHERE SIGNUP_ID=@p_var_UserId

				INSERT INTO [dbo].[USER_POSTS] (USER_ID,
													POST_DATE,
													POST_VIDEO_URL,
													POST_PHOTO_URL,
													--POST_HEADLINE_1,
													POST_HEADLINE_2,
													POST_WEBSITE_LINK,
													POST_VIEW_OPTION_POSTVIEW_OPTION_ID,
													POST_HAS_PHOTO,
													POST_HAS_VIDEO,
													POST_IS_PUBLISH,
													POST_CONTAINT
													)
													 VALUES(@USERID,
													 @p_var_PostDate,
													 @p_var_VideoUrl,
													 @p_var_PhotoUrl,
													-- @p_var_PostHeadLine1,
													 @p_var_PostHeadLine2,
													 @p_var_PostWebLink,
													 @p_var_PostViewOptionId,
													 @p_var_Hasphoto,
													 @p_var_Hasvideo,
													 @p_var_Ispublish,
													 @p_var_PostData
													 )
				SELECT @Post_ID=@@IDENTITY;

				IF @p_var_PostTag <> ''
				BEGIN

					INSERT INTO TAGS_MASTER(TAG_KEYWORD)  SELECT String FROM splitFunction (@p_var_PostTag,',' ) 
					WHERE NOT EXISTS(SELECT TAG_KEYWORD FROM TAGS_MASTER WHERE TAG_KEYWORD=String);

					INSERT INTO USER_POSTS_TAGS(USER_ID,
												POST_ID,
												TAGS_ID)  
					SELECT @USERID,@Post_ID,TM.ID FROM TAGS_MASTER TM 
					WHERE  EXISTS(SELECT String FROM splitFunction (@p_var_PostTag,',' ) WHERE String=TM.TAG_KEYWORD)
				END 

				IF @p_var_PostExpertise <> ''
				BEGIN

					
					INSERT INTO USER_POST_EXPERTISE(USER_POSTS_USER_ID,
													USER_POSTS_POST_ID,
													EXPERTISE_AREA_ID) 

					SELECT @USERID,@Post_ID,String FROM splitFunction (@p_var_PostExpertise,',' )  

				END 

				IF @p_var_PostMood <> ''
				BEGIN

					
					INSERT INTO USER_POST_MOODS(USER_POSTS_USER_ID,
													USER_POSTS_POST_ID,
													MOODS_ID) 

					SELECT @USERID,@Post_ID,String FROM splitFunction (@p_var_PostMood,',' )  

				END 

				SELECT @Post_ID AS POST_ID
		END TRY
			BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH 

END



GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_Follow_UnFollow_Friend]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_Follow_UnFollow_Friend] 
	-- Add the parameters for the stored procedure here
	@p_senderSignupID BIGINT,
	@p_ReceiverSignupID BIGINT,
	@p_varFlag varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE
	@p_SnederUserID BIGINT,
	@p_ReceiverUserID BIGINT


	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT @p_SnederUserID=USER_ID FROM USER_PROFILE WHERE SIGNUP_ID=@p_senderSignupID

	SELECT @p_ReceiverSignupID=USER_ID FROM USER_PROFILE WHERE SIGNUP_ID=@p_ReceiverSignupID

	IF @p_varFlag='INSERT'
	BEGIN 

	 if exists(SELECT * FROM [dbo].[USER_FOLLOWERS] WHERE USER_ID=@p_ReceiverSignupID
	AND FOLLOWER_USER_ID=@p_SnederUserID AND DELETE_FLAG=1)
	BEGIN
	UPDATE [dbo].[USER_FOLLOWERS] SET DELETE_FLAG=0 WHERE USER_ID=@p_ReceiverSignupID
	AND FOLLOWER_USER_ID=@p_SnederUserID
	END
	ELSE
	
	BEGIN
	INSERT INTO [dbo].[USER_FOLLOWERS](USER_ID,FOLLOWER_USER_ID,DELETE_FLAG) 
	VALUES(@p_ReceiverSignupID,@p_SnederUserID,0)
	END
	

	END
	ELSE
	BEGIN 
	UPDATE [dbo].[USER_FOLLOWERS] SET DELETE_FLAG=1 WHERE USER_ID=@p_ReceiverSignupID
	AND FOLLOWER_USER_ID=@p_SnederUserID


	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_FRIEND_ORFOLLOWER]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Siddhu,,Name>
-- Create date: <21-sept-2016,,>
-- Description:	<to send friend request and follow friend ,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_FRIEND_ORFOLLOWER]
	-- Add the parameters for the stored procedure here
	@p_signup_sender INT,
	@p_signup_receiver INT,
	@p_flag_FF INT
AS
DECLARE
@p_sender_userid INT,
@p_receiver_userid INT,
@p_return INT,
@p_count_ INT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
     SELECT @p_sender_userid=USER_ID FROM 
	 USER_PROFILE WHERE
	 SIGNUP_ID = @p_signup_sender

     SELECT @p_receiver_userid = USER_ID
	 FROM USER_PROFILE WHERE SIGNUP_ID = @p_signup_receiver
    
		IF @p_flag_FF = 1 

		BEGIN

			SELECT @p_count_=COUNT(*) From FRIENDS_REQUESTS WHERE 
			SENTBY_USER_ID=@p_sender_userid AND 
			RECEIVEDBY_USER_ID=@p_receiver_userid 
			AND REQUEST_STATUS=2
		
			IF @p_count_=0
			BEGIN
			INSERT INTO FRIENDS_REQUESTS 
			(SENTBY_USER_ID ,RECEIVEDBY_USER_ID,REQUEST_STATUS,REQ_SENT_DATE)
			VALUES (@p_sender_userid,@p_receiver_userid,0,GETDATE())
			END
			ELSE 
			BEGIN

			UPDATE FRIENDS_REQUESTS SET REQUEST_STATUS=0,REQUEST_SEEN=0,
			REQ_SENT_DATE=GETDATE()
			WHERE SENTBY_USER_ID=@p_sender_userid AND
			RECEIVEDBY_USER_ID=@p_receiver_userid 
			AND REQUEST_STATUS=2
			END
			SELECT @p_return = 1 
		END
	ELSE

		BEGIN
			INSERT INTO USER_FOLLOWERS 
			(USER_ID ,FOLLOWER_USER_ID) 
			VALUES(@p_sender_userid,@p_receiver_userid)
			SELECT @p_return = 2 
		END

		SELECT @p_return AS STATUS
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_MoodsInfo]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 17-SEPT
-- Description:	INSERT MOODS FOR DAY AGAINST USER
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_MoodsInfo]
	-- Add the parameters for the stored procedure here
	@p_user_id INT,
	@p_moods_id INT
AS


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @chk int;

     --SELECT COUNT(USER_ID) FROM USER_MOOD_FORDAY WHERE USER_ID = @p_user_id;
IF EXISTS(SELECT USER_ID FROM USER_MOOD_FORDAY WHERE USER_ID = @p_user_id)
UPDATE USER_MOOD_FORDAY SET MOOD = @p_moods_id , MOOD_DATE = GETDATE() WHERE USER_ID = @p_user_id;

ELSE 
INSERT INTO USER_MOOD_FORDAY ( USER_ID,MOOD,MOOD_DATE)VALUES (@p_user_id,@p_moods_id, GETDATE());
	
END


GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_OR_UPDATE_LIKE_DISLIKE]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_OR_UPDATE_LIKE_DISLIKE] 
	-- Add the parameters for the stored procedure here
	@USERID INT,
	@POSTID INT,
	@LikeUSERID INT,
	@FLAG VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @LIKECOUNT INT,
	@DISLIKECOUNT INT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @FLAG='LIKE'
	BEGIN
	IF exists (
	SELECT * FROM [dbo].[USER_POSTS_LIKE] WHERE POST_ID=@POSTID
	AND LIKE_USER_ID= @LikeUSERID
	)

	BEGIN

	DELETE FROM [dbo].[USER_POSTS_LIKE] WHERE POST_ID=@POSTID
	AND LIKE_USER_ID= @LikeUSERID AND USER_ID=@USERID



	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[USER_POSTS_LIKE] (USER_ID,POST_ID,LIKE_USER_ID)
	VALUES(@USERID,@POSTID,@LikeUSERID)



	DELETE FROM [dbo].[USER_POSTS_DISLIKE] WHERE POST_ID=@POSTID
	AND DISLIKE_USER_ID= @LikeUSERID AND USER_ID=@USERID

	END
	END 

	ELSE
	BEGIN

	IF exists (
	SELECT * FROM [dbo].[USER_POSTS_DISLIKE] WHERE POST_ID=@POSTID
	AND DISLIKE_USER_ID= @LikeUSERID
	)

	BEGIN

	DELETE FROM [dbo].[USER_POSTS_DISLIKE] WHERE POST_ID=@POSTID
	AND DISLIKE_USER_ID= @LikeUSERID AND USER_ID=@USERID

	END
	ELSE
	BEGIN
	INSERT INTO [dbo].[USER_POSTS_DISLIKE] (USER_ID,POST_ID,DISLIKE_USER_ID)
	VALUES(@USERID,@POSTID,@LikeUSERID)

	DELETE FROM [dbo].[USER_POSTS_LIKE] WHERE POST_ID=@POSTID
	AND LIKE_USER_ID= @LikeUSERID AND USER_ID=@USERID

	END


	END

	SELECT @LIKECOUNT=COUNT(*) FROM [dbo].[USER_POSTS_LIKE] 
	WHERE POST_ID=@POSTID

	SELECT @DISLIKECOUNT=COUNT(*) FROM [dbo].[USER_POSTS_DISLIKE] 
	WHERE POST_ID=@POSTID
	

	SELECT @LIKECOUNT AS LIKECOUNT ,@DISLIKECOUNT AS DISLIKECOUNT
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_PROFILE_PHOTO]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 24-SEPT-2016
-- Description:	TO SAVE PROFILE PHOTO
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_PROFILE_PHOTO]
	-- Add the parameters for the stored procedure here
	@p_signup_id int,
	@p_profile_photo varchar(300)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE USER_PROFILE SET PROFILE_PHOTO = @p_profile_photo WHERE SIGNUP_ID = @p_signup_id
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_RELATIONSHIP]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 04-OCT-2016
-- Description:	To save the relationship for the user.
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_RELATIONSHIP]
	-- Add the parameters for the stored procedure here
	@p_sender_id int,
	@p_recevier_id int,
	@p_relationship varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
IF EXISTS(SELECT SENDER_ID,RECEVIER_ID FROM USER_RELATIONSHIP WHERE SENDER_ID = @p_sender_id AND RECEVIER_ID = @p_recevier_id AND RELATIONSHIP_ID = @p_relationship)
     BEGIN
     DELETE FROM USER_RELATIONSHIP WHERE SENDER_ID = @p_sender_id AND RECEVIER_ID = @p_recevier_id;

     INSERT INTO USER_RELATIONSHIP ( SENDER_ID,RECEVIER_ID,RELATIONSHIP_ID)VALUES (@p_sender_id,@p_recevier_id, @p_relationship);
END
ELSE
 
  INSERT INTO USER_RELATIONSHIP ( SENDER_ID,RECEVIER_ID,RELATIONSHIP_ID)VALUES (@p_sender_id,@p_recevier_id, @p_relationship);
	
END
	

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_REMOVEPOST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 05-NOV-16
-- Description:	TO INSERT REMOVE POST AGAINST USER ID
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_REMOVEPOST]
	-- Add the parameters for the stored procedure here
	@p_userid bigint,
	@p_postid bigint,
	@p_post_userid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT * FROM REMOVE_POST WHERE USER_ID=@p_userid AND POST_ID=@p_postid )
	BEGIN

    -- Insert statements for procedure here
	INSERT INTO dbo.REMOVE_POST (USER_ID,POST_ID,POST_USER_ID) VALUES(@p_userid,@p_postid,@p_post_userid);
    END
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_REPLY_MAIL]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 25-oct-2016
-- Description:	to reply the mail
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_REPLY_MAIL]
	-- Add the parameters for the stored procedure here
	@p_email_num int,
	@p_var_Subject varchar(MAX),
	@p_var_Body varchar(MAX)
	
AS

DECLARE 
@p_from_id int,
@p_to_id int
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_from_id = FROM_USER_ID,
	@p_to_id =TO_USER_ID
	 from USER_EMAILS WHERE EMAILIDNUMBER =@p_email_num;
	 
	INSERT INTO [dbo].[USER_EMAILS] (FROM_USER_ID,TO_USER_ID,EMAIL_SUBJECT,EMAIL_DATE,EMAIL_BODY,PARENTEMAILIDNUMBER)
	VALUES(@p_to_id,@p_from_id,@p_var_Subject,GETDATE(),@p_var_Body,@p_email_num) 
	 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_ResetLinkID]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_ResetLinkID] 
	-- Add the parameters for the stored procedure here
	@p_var_Eamil varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@User_ID bigint,
	@Unique_ID uniqueidentifier

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT USER_ID FROM [dbo].[USER_PROFILE] UP JOIN SIGNUP_INFO SI ON SI.ID=UP.SIGNUP_ID WHERE SI.SIGNUP_EMAIL=@p_var_Eamil)
				BEGIN	
						SELECT @User_ID=USER_ID
						FROM [dbo].[USER_PROFILE]
						UP JOIN SIGNUP_INFO SI 
						ON SI.ID=UP.SIGNUP_ID
						WHERE SI.SIGNUP_EMAIL=@p_var_Eamil

						UPDATE [dbo].[FORGOT_PWD] SET IS_LINK_ACTIVE=0 WHERE USER_ID = @User_ID
						SELECT @Unique_ID=NEWID();
						INSERT INTO [dbo].[FORGOT_PWD](USER_ID,LINK_ID,IS_LINK_ACTIVE)
						VALUES (@User_ID,@Unique_ID,1)

						SELECT @Unique_ID AS UID,FIRST_NAME,LAST_NAME FROM [dbo].[USER_PROFILE]
						UP JOIN SIGNUP_INFO SI 
						ON SI.ID=UP.SIGNUP_ID
						WHERE SI.SIGNUP_EMAIL=@p_var_Eamil
				END

				ELSE
				BEGIN	

						SELECT 0 AS UID,0 AS FIRST_NAME, 0 AS LAST_NAME

				END

END



GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_SendEmail]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_SendEmail] 
	-- Add the parameters for the stored procedure here
	@p_var_SenderSignUpID BiGINT,
	@p_var_ReceiverSignUpID BiGINT,
	@p_var_Subject varchar(MAX),
	@p_var_Body varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE 
	@Sender_UserID BIGINT,
	@Receiver_SignUpId BIGINT


    -- Insert statements for procedure here
	SELECT @Sender_UserID=USER_ID 
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SenderSignUpID

	SELECT @Receiver_SignUpId=USER_ID 
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_ReceiverSignUpID


	INSERT INTO [dbo].[USER_EMAILS] (FROM_USER_ID,
	TO_USER_ID,
	EMAIL_SUBJECT,
	EMAIL_DATE,
	EMAIL_BODY)
	VALUES(@Sender_UserID,
	@Receiver_SignUpId,
	@p_var_Subject,
	GETDATE(),
	@p_var_Body)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_SHAREPOST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 05-NOV-2015
-- Description:	TO INSERT THE SHARE POST ID 
-- =============================================
CREATE PROCEDURE [dbo].[USP_INSERT_SHAREPOST]
	-- Add the parameters for the stored procedure here
	@p_userid bigint,
	@p_postid bigint,
	@p_post_usetid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS (SELECT * FROM SHARE_POST WHERE USER_ID=@p_userid AND POST_ID=@p_postid )
	BEGIN
	INSERT INTO dbo.SHARE_POST ( USER_ID,POST_ID,POST_USER_ID)VALUES (@p_userid,@p_postid, @p_post_usetid);
	END
END




GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ALL_FOLLOWING]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 28-sept-2016
-- Description:	To get all connection details of following user.
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ALL_FOLLOWING]
	-- Add the parameters for the stored procedure here
   @p_signup_id int,
   @p_start int,
   @p_end int
AS
DECLARE
@p_UserID INT
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    SELECT @p_UserID = USER_ID FROM USER_PROFILE
	     WHERE SIGNUP_ID=@p_signup_id;
	     
    -- Insert statements for procedure here
	/*To select all following */
			
			WITH IDRecords AS (
			SELECT DISTINCT  1 AS TABLE0,PR.SIGNUP_ID, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME,
		    PR.JOB_TITLE,convert(char(13),PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH,
		    PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL,
		    ROW_NUMBER() OVER (ORDER BY SIGNUP_ID ASC) AS ID 
		    FROM USER_FOLLOWERS UR
		    INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
		    INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
		    WHERE UR.DELETE_FLAG =0 AND UR.FOLLOWER_USER_ID =@p_UserID
		    )
		   SELECT * FROM IDRecords WHERE ID BETWEEN @p_start and @p_end 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ALLCONNECTION_DETAILS]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 28-sept-2016
-- Description:	To get all connection details for user.
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ALLCONNECTION_DETAILS]
	-- Add the parameters for the stored procedure here
   @p_signup_id int,
   @p_where varchar(30),
   @p_start int,
   @p_end int
AS
DECLARE
@p_UserID INT
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	     SELECT @p_UserID = USER_ID FROM USER_PROFILE
	     WHERE SIGNUP_ID=@p_signup_id

     If @p_where=0 
     BEGIN 
		  
		  WITH IDRecords AS (
          SELECT DISTINCT  1 AS TABLE0,
		  PR.SIGNUP_ID ,PR.FIRST_NAME,
		  PR.LAST_NAME,PR.PROFILE_PHOTO,
		  PR.USER_NAME,
		  PR.JOB_TITLE,convert(char(13),
		  PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		  PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL, 
		  ISNULL(STUFF((SELECT CAST( CM.Contact_name AS varchar(50))+ ','  from USER_RELATIONSHIP UR 
	      INNER JOIN Conatct_Master CM ON UR.RELATIONSHIP_ID = CM.Contact_Id
	      WHERE UR.SENDER_ID=@p_signup_id  AND(UR.RECEVIER_ID = PR.SIGNUP_ID) 
          FOR XML PATH(''), TYPE).value('.','VARCHAR(MAX)'),1,0,'') ,'') as RELATION_NAME--,
          --ROW_NUMBER() OVER (ORDER BY PR.SIGNUP_ID ASC) AS ID    
		  FROM USER_PROFILE PR
		  INNER JOIN FRIENDS_REQUESTS FR ON (PR.USER_ID = FR.SENTBY_USER_ID OR PR.USER_ID =FR.RECEIVEDBY_USER_ID)
		  INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
		  LEFT JOIN USER_RELATIONSHIP UR ON ( PR.SIGNUP_ID =UR.RECEVIER_ID AND UR.SENDER_ID =@p_signup_id)
		  WHERE (FR.SENTBY_USER_ID = @p_UserID OR FR.RECEIVEDBY_USER_ID = @p_UserID)
		  AND FR.REQUEST_STATUS = 1 AND PR.SIGNUP_ID != @p_signup_id 
		  ),
		  IDRecords2 as(
		  select *,ROW_NUMBER() OVER (ORDER BY IDRecords.SIGNUP_ID ASC) AS ID from IDRecords)
		  
		  SELECT * FROM IDRecords2 WHERE ID BETWEEN @p_start and @p_end
		  
			
		END
		ELSE IF(@p_where=3 OR @p_where=4 OR @p_where=5 OR @p_where=6 OR @p_where=7 OR @p_where=8)
		BEGIN
		 WITH IDRecords AS (
          SELECT DISTINCT  1 AS TABLE0, PR.SIGNUP_ID ,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME,
		   PR.JOB_TITLE,convert(char(13),PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		   PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL, 
		   ISNULL(STUFF((SELECT CAST( CM.Contact_name AS varchar(50))+ ','  from USER_RELATIONSHIP UR 
	       INNER JOIN Conatct_Master CM ON UR.RELATIONSHIP_ID = CM.Contact_Id
	       WHERE UR.RECEVIER_ID = PR.SIGNUP_ID AND UR.SENDER_ID=@p_signup_id  
           FOR XML PATH(''), TYPE).value('.','VARCHAR(MAX)'),1,0,'') ,'') as RELATION_NAME
		   FROM USER_PROFILE PR
		   INNER JOIN FRIENDS_REQUESTS FR ON (PR.USER_ID = FR.SENTBY_USER_ID OR PR.USER_ID =FR.RECEIVEDBY_USER_ID)
		   INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
		   LEFT JOIN USER_RELATIONSHIP UR ON ( PR.SIGNUP_ID =UR.RECEVIER_ID AND UR.SENDER_ID =@p_signup_id)
		   WHERE (FR.SENTBY_USER_ID = @p_UserID OR FR.RECEIVEDBY_USER_ID = @p_UserID) 
		   AND FR.REQUEST_STATUS = 1 AND PR.SIGNUP_ID != @p_signup_id AND UR.RELATIONSHIP_ID = @p_where
		   ),
		  IDRecords2 as(
		  select *,ROW_NUMBER() OVER (ORDER BY IDRecords.SIGNUP_ID ASC) AS ID from IDRecords)
		  
		  SELECT * FROM IDRecords2 WHERE ID BETWEEN @p_start and @p_end
		   
		END	
			/*To select all following */
		/*ELSE		
			BEGIN
			
			WITH IDRecords AS (
			SELECT DISTINCT  1 AS TABLE0,PR.SIGNUP_ID, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME,
		    PR.JOB_TITLE,convert(char(13),PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH,
		    PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL,
		    ROW_NUMBER() OVER (ORDER BY SIGNUP_ID DESC) AS ID 
		    FROM USER_FOLLOWERS UR
		    INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
		    INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
		    WHERE UR.DELETE_FLAG =0 AND UR.FOLLOWER_USER_ID =@p_UserID
		    )
		   SELECT * FROM IDRecords WHERE ID BETWEEN @p_start and @p_end 
		   END
		  */
			
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CHAT_FRIENDLIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 19-oct-2016
-- Description:to get the chat list of user 
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_CHAT_FRIENDLIST]
	-- Add the parameters for the stored procedure here

	@p_user_id int,
	@p_var_start int,
	@p_var_end int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   --   ;WITH USERLIST AS(
			--SELECT PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO FROM USER_PROFILE PR
			--INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			--WHERE SENTBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
			--UNION ALL 
			
			--SELECT PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO FROM USER_PROFILE PR
			--INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			--WHERE RECEIVEDBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
			--UNION ALL 
			
			--SELECT PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO
		 --   FROM USER_FOLLOWERS UR
		 --   INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
		 --   WHERE UR.DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_user_id
			--),
			-- TOCHATUSer AS 
			--(
			--	SELECT UC.TO_USER_ID ,UC.CHAT_DATE,
			--	ROW_NUMBER() OVER (PARTITION BY UC.TO_USER_ID ORDER BY UC.CHAT_DATE DESC) AS ROWNUM
			--	FROM USER_CHATS UC WHERE UC.FROM_USER_ID=@p_user_id

			--),
			--FromCHATUSer AS(
			--SELECT UC.FROM_USER_ID,UC.CHAT_DATE,
			--	ROW_NUMBER() OVER (PARTITION BY UC.FROM_USER_ID ORDER BY UC.CHAT_DATE DESC) AS ROWNUM
			--	FROM USER_CHATS UC WHERE UC.TO_USER_ID=@p_user_id
			--),
			--USERLISTALLCONNECT AS
			--(
			--select TO_USER_ID AS USER_ID,CHAT_DATE from TOCHATUSer  WHERE ROWNUM = 1 
			--UNION  ALL 
			--select FROM_USER_ID AS USER_ID,CHAT_DATE from FromCHATUSer  WHERE ROWNUM = 1 
			--),
			--USERLISTALLCONNECT_ALL AS
			--(
			--	select UL.USER_ID,
			--	UL.FIRST_NAME,
			--	UL.LAST_NAME,
			--	UL.PROFILE_PHOTO,
			--	ULL.CHAT_DATE,
			--	ROW_NUMBER() OVER (ORDER BY ULL.CHAT_DATE DESC,UL.USER_ID DESC) AS ID 
			--	FROM USERLIST UL 
			--	LEFT JOIN  
			--	USERLISTALLCONNECT ULL ON UL.USER_ID=ULL.USER_ID
			--)

			--select * from USERLISTALLCONNECT_ALL where ID BETWEEN @p_var_start AND @p_var_end
		
			;WITH USERLIST AS(
			SELECT 
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID FROM USER_PROFILE PR
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			WHERE SENTBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
			UNION ALL 
			
			SELECT 
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID FROM USER_PROFILE PR
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			WHERE RECEIVEDBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			UNION ALL 
		    SELECT 
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID
		    FROM USER_FOLLOWERS UR

		    INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
		    WHERE UR.DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_user_id
			),
			 TOCHATUSer AS 
			(
				SELECT 
				UC.TO_USER_ID ,UC.CHAT_DATE,
				ROW_NUMBER() OVER (PARTITION BY UC.TO_USER_ID ORDER BY UC.CHAT_DATE DESC) AS ROWNUM
				FROM USER_CHATS UC WHERE UC.FROM_USER_ID=@p_user_id

			),
			FromCHATUSer AS(
				SELECT UC.FROM_USER_ID,UC.CHAT_DATE,
				ROW_NUMBER() OVER (PARTITION BY UC.FROM_USER_ID ORDER BY UC.CHAT_DATE DESC) AS ROWNUM
				FROM USER_CHATS UC WHERE UC.TO_USER_ID=@p_user_id
			),
			USERLISTALLCONNECT AS
			(
		    select TO_USER_ID AS USER_ID,CHAT_DATE from TOCHATUSer  WHERE ROWNUM = 1 
		       UNION  ALL 
		    select FROM_USER_ID AS USER_ID,CHAT_DATE from FromCHATUSer  WHERE ROWNUM = 1 
			),
			USERLISTALLCONNECT2 AS
			(
			SELECT USER_ID,CHAT_DATE,
		    ROW_NUMBER() OVER (PARTITION BY USER_ID ORDER BY CHAT_DATE DESC) AS ROWNUM
		    FROM USERLISTALLCONNECT UE 
			),
			USERLISTALLCONNECT3 AS
			(
			SELECT 
				* FROM USERLISTALLCONNECT2  WHERE ROWNUM = 1 
			),

			USERLISTALLCONNECT_ALL AS
			(
				select UL.USER_ID,
				UL.FIRST_NAME,
				UL.LAST_NAME,
				UL.PROFILE_PHOTO,
				UL.SIGNUP_EMAIL,
				UL.SIGNUP_ID,
				ULL.CHAT_DATE,
				ROW_NUMBER() OVER (ORDER BY ULL.CHAT_DATE DESC,UL.USER_ID DESC) AS ID
				FROM USERLIST UL 
				LEFT JOIN  
				USERLISTALLCONNECT3 ULL ON UL.USER_ID=ULL.USER_ID

			)

			select * from USERLISTALLCONNECT_ALL where ID BETWEEN @p_var_start AND @p_var_end
			
			
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CHATUSERLIST_RECENT]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 19-oct-2016
-- Description:	to select the chat list of all user
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_CHATUSERLIST_RECENT]
   
    @p_Main_UserID BIGINT,
	@p_Search_UserID BIGINT,
	@p_Start INT,
	@p_END INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	;WITH RECORD AS(
	SELECT CHAT_DATE,CHAT_MESSAGE,TO_USER_ID,FROM_USER_ID,IS_SEEN,
	ROW_NUMBER() OVER (ORDER BY CHAT_DATE desc) AS ID 
	FROM dbo.USER_CHATS UC WHERE (FROM_USER_ID=@p_Main_UserID AND TO_USER_ID=@p_Search_UserID)
	OR (TO_USER_ID=@p_Main_UserID AND FROM_USER_ID=@p_Search_UserID)),
	RECORDALL AS(
	
	SELECT convert(varchar(100),CHAT_DATE)AS CHAT_DATE,
	CHAT_MESSAGE,UP.PROFILE_PHOTO,UP.FIRST_NAME,UP.LAST_NAME,ID FROM RECORD
	LEFT JOIN USER_PROFILE UP ON FROM_USER_ID = UP.USER_ID
    WHERE ID BETWEEN @p_Start AND @p_END)
    
    select * from RECORDALL order by ID DESC

END
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_CONNECTION_SEARCH]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 13-oct-16
-- Description:	to get the connection list
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_CONNECTION_SEARCH]
    @p_var_UserName varchar(30),
	@p_var_UserSignupId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

	
	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE SIGNUP_ID = @p_var_UserSignupId

    -- Insert statements for procedure here
	
		;WITH RECORD AS(
		SELECT SENTBY_USER_ID  AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_UserID) AND REQUEST_STATUS<>2
		UNION
		
		SELECT RECEIVEDBY_USER_ID AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_UserID AND REQUEST_STATUS<>2
		UNION
		
		SELECT USER_ID AS USERID 
		FROM  [dbo].[USER_FOLLOWERS] WHERE 
		FOLLOWER_USER_ID=@p_UserID AND DELETE_FLAG<>1
		UNION 
		
		SELECT REMOVE_USER_ID AS USERID 
		FROM  [dbo].[USER_SUGGESTION_REMOVE] WHERE 
		USER_ID=@p_UserID
		)


	SELECT DISTINCT 1 AS TABLE1, 
		UP.*,isnull(UF.USER_ID,0) as Follow FROM  [dbo].[USER_PROFILE] UP LEFT Join 
		USER_FOLLOWERS UF ON UF.USER_ID=UP.USER_ID AND UF.DELETE_FLAG=0
		LEFT JOIN RECORD R ON UP.USER_ID = R.USERID 
		WHERE R.USERID IS NULL AND UP.USER_ID <> @p_UserID AND
	     ((UPPER(UP.FIRST_NAME) LIKE '%' + @p_var_UserName + '%' ) OR
	     (UPPER(UP.LAST_NAME) LIKE '%' + @p_var_UserName + '%' ) ) AND UP.USER_ID<>@p_UserID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPhotoPostWithPagination]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPhotoPostWithPagination] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_IS_PUBLISH DESC,POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO ,
	UP.POST_IS_PUBLISH,

	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_PHOTO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 ISNULL(POST_HEADLINE_2,'') AS POST_HEADLINE_2,
	 POST_PHOTO_URL,
	  POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_PHOTO=1 AND ID BETWEEN @p_var_Start AND @p_var_End ORDER BY POST_IS_PUBLISH DESC, POST_DATE DESC, POST_ID DESC
	
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPhotoPostWithPaginationASC]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPhotoPostWithPaginationASC] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT,
	@p_var_Sort varchar(10)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId
	IF @p_var_Sort='ASC'

	BEGIN
	

	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE ASC,POST_ID ASC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_PHOTO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_PHOTO=1 AND ID BETWEEN @p_var_Start AND @p_var_End --ORDER BY POST_DATE ASC, POST_ID ASC
	
	END

	ELSE 
	BEGIN

		;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_PHOTO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_PHOTO=1 AND ID BETWEEN @p_var_Start AND @p_var_End --ORDER BY POST_DATE ASC, POST_ID ASC
	
	END

	END
	





GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPost]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPost] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,
	@p_var_Order INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	IF @p_var_Order = 1

	BEGIN

	SELECT  DISTINCT POST_ID,
	UP.USER_ID,
	UP.POST_DATE,
	UP.POST_HEADLINE_1,
	UP.POST_PHOTO_URL ,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISE
	FROM [dbo].[USER_POSTS] UP
	
	LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	EXPERTISE_AREA_MASTER UAM ON 
	UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID
	ORDER BY UP.POST_DATE DESC, POST_ID DESC
	END
	ELSE

	BEGIN

	SELECT  DISTINCT POST_ID,
	UP.USER_ID,
	UP.POST_DATE,
	UP.POST_HEADLINE_1,
	UP.POST_PHOTO_URL ,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISE
	FROM [dbo].[USER_POSTS] UP
	
	LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	EXPERTISE_AREA_MASTER UAM ON 
	UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID
	ORDER BY UP.POST_DATE ASC, POST_ID ASC
	END

END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPagination]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPagination] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	;WITH RECORD AS (

	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_IS_PUBLISH DESC,POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,

	UP.POST_DATE,

	ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,

	UP.POST_HEADLINE_2,

	UP.POST_PHOTO_URL ,
	UP.POST_IS_PUBLISH,

	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	  POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End ORDER BY POST_IS_PUBLISH DESC,POST_DATE DESC, POST_ID DESC
	
	


	

END


select * from EXPERTISE_AREA_MASTER
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPaginationASC]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPaginationASC] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT,
	@p_var_Sort varchar(10)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	IF @p_var_Sort='ASC'
	
	BEGIN
	
	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE ASC,POST_ID ASC) AS ID,
	UP.USER_ID,

	UP.POST_DATE,

		ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
		UP.POST_HEADLINE_2,
		UP.POST_IS_PUBLISH,
	UP.POST_PHOTO_URL ,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	  POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End --ORDER BY  POST_DATE ASC, POST_ID ASC
	
	END

	ELSE
	BEGIN 
	
	
	;WITH RECORD AS (

	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,

	UP.POST_DATE,

		ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
		UP.POST_HEADLINE_2,
		UP.POST_IS_PUBLISH,
	UP.POST_PHOTO_URL ,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	  POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End --ORDER BY  POST_DATE DESC, POST_ID DESC

	END



	

END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsPostWithPaginationDummy]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsPostWithPaginationDummy] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
	UP.POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,

	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'ALL'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	
	WHERE UP.USER_ID=@USER_ID
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 CASE 
	   WHEN EXPERTISESingle = 'ALL,'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'ALL,'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End ORDER BY POST_DATE DESC, POST_ID DESC
	
	


	

END


SELECT * FROM [dbo].[USER_EXPERTISE]
SELECT * FROM [dbo].[USER_PROFILE]
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsSelectedPost]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsSelectedPost] 
	-- Add the parameters for the stored procedure here
	@p_var_PostId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT @USER_ID = USER_ID
	--FROM USER_PROFILE 
	--WHERE SIGNUP_ID=@p_var_SignupId


	SELECT  DISTINCT POST_ID,
	UP.USER_ID,
	CONVERT(VARCHAR(100),UP.POST_DATE) AS POST_DATE,
	UP.POST_DATE AS POST_DATE2,
	UP.POST_HEADLINE_1,
	UP.POST_HAS_PHOTO,
	UP.POST_HAS_VIDEO,
	UP.POST_HEADLINE_2,
	UP.POST_VIDEO_URL,
	UP.POST_PHOTO_URL ,
	UP.POST_WEBSITE_LINK,
	UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID,
	ISNULL(STUFF((SELECT CAST( M.ID AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID 
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=@p_var_PostId
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISE,

	ISNULL(STUFF((SELECT CAST( M.MOODS_ID AS varchar(50))+ ','  FROM USER_POST_MOODS M LEFT JOIN 
	USER_POSTS UP ON UP.POST_ID=M.USER_POSTS_POST_ID
	WHERE UP.POST_ID=@p_var_PostId
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as Mood,

	ISNULL(STUFF((SELECT CAST( M.TAG_KEYWORD AS varchar(50))+ ','  FROM [dbo].[TAGS_MASTER] M INNER JOIN 
	[dbo].[USER_POSTS_TAGS] UT ON M.ID=UT.TAGS_ID 

	WHERE UT.POST_ID=@p_var_PostId
    FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as Tag
	FROM [dbo].[USER_POSTS] UP
	
	LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	ON UP.POST_ID=UPE.USER_POSTS_POST_ID LEFT JOIN 
	EXPERTISE_AREA_MASTER UAM ON 
	UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.POST_ID=@p_var_PostId
	ORDER BY POST_DATE2 DESC, POST_ID DESC


END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsVideoPostWithPagination]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsVideoPostWithPagination] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId

	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_IS_PUBLISH DESC,POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
	ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_VIDEO ,
		UP.POST_IS_PUBLISH,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_VIDEO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1, 
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	  POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_VIDEO=1 AND ID BETWEEN @p_var_Start AND @p_var_End ORDER BY  POST_IS_PUBLISH DESC,POST_DATE DESC, POST_ID DESC
	
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ContributorsVideoPostWithPaginationASC]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ContributorsVideoPostWithPaginationASC] 
	-- Add the parameters for the stored procedure here
	@p_var_SignupId BIGINT,

	@p_var_Start INT,
	@p_var_End INT,
	@p_var_Sort varchar(10)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@USER_ID BIGINT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @USER_ID = USER_ID
	FROM USER_PROFILE 
	WHERE SIGNUP_ID=@p_var_SignupId
	IF @p_var_Sort='ASC'

	BEGIN
	
	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE ASC,POST_ID ASC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
		ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
		UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_VIDEO,
	UP.POST_IS_PUBLISH,

	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_VIDEO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_VIDEO=1 AND ID BETWEEN @p_var_Start AND @p_var_End ORDER BY POST_DATE ASC, POST_ID ASC
	
	END
	ELSE
	BEGIN
	
	;WITH RECORD AS (
	SELECT  DISTINCT POST_ID,ROW_NUMBER() OVER (ORDER BY POST_DATE DESC,POST_ID DESC) AS ID,
	UP.USER_ID,
	UP.POST_DATE,
		ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
		UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_VIDEO,
	UP.POST_IS_PUBLISH,
	ISNULL(STUFF((SELECT CAST( M.EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER M INNER JOIN 
	[dbo].[USER_POST_EXPERTISE] UT ON M.ID=UT.EXPERTISE_AREA_ID AND UT.USER_POSTS_USER_ID=@USER_ID
	WHERE UT.EXPERTISE_AREA_ID=M.ID   AND UT.USER_POSTS_POST_ID=UP.POST_ID
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISESingle,
	
	ISNULL(STUFF((SELECT CAST( EXPERTISE_NAME AS varchar(50))+ ','  FROM EXPERTISE_AREA_MASTER 
	WHERE EXPERTISE_NAME <>'LIFE (ALL)'
            FOR XML PATH(''), TYPE
    ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as EXPERTISEAll
	FROM [dbo].[USER_POSTS] UP
	
	--LEFT JOIN [dbo].[USER_POST_EXPERTISE] UPE 
	--ON UP.POST_ID=UPE.USER_POSTS_POST_ID INNER JOIN 
	--EXPERTISE_AREA_MASTER UAM ON 
	--UPE.EXPERTISE_AREA_ID=UAM.ID
	WHERE UP.USER_ID=@USER_ID AND POST_HAS_VIDEO=1
	
	)

	 SELECT DISTINCT POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 POST_IS_PUBLISH,
	 CASE 
	   WHEN EXPERTISESingle = 'LIFE (ALL),'
			THEN 
			EXPERTISEAll  
	   WHEN EXPERTISESingle <> 'LIFE (ALL),'
	       THEN 
			EXPERTISESingle  
	 END AS EXPERTISE
	 FROM RECORD
	 WHERE RECORD.POST_HAS_VIDEO=1 AND ID BETWEEN @p_var_Start AND @p_var_End --ORDER BY POST_DATE ASC, POST_ID ASC
	
	END


	

END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ExpertiseArea]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ExpertiseArea] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT	ID,
				EXPERTISE_NAME FROM
		[dbo].[EXPERTISE_AREA_MASTER] ORDER BY ID ASC
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FriendRequestList]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_FriendRequestList] 
	-- Add the parameters for the stored procedure here
	@p_var_UserSignupId BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @p_var_UserSignupId

		SELECT 1 As FRIEND_Request,UP.FIRST_NAME,
		UP.LAST_NAME,
		UP.PROFILE_PHOTO,
		UP.SIGNUP_ID,
		UP.USER_ID,
		UP.USER_TITLE,
		UP.DATE_OF_BIRTH
		FROM   [dbo].[FRIENDS_REQUESTS]   FR
		INNER JOIN 
		[dbo].[USER_PROFILE] UP 
		ON SENTBY_USER_ID=USER_ID 
		WHERE RECEIVEDBY_USER_ID = @p_UserID
		AND REQUEST_STATUS=0 AND DELETE_FLAG=0


		--EXEC USP_SELECT_SuggestionList @p_var_UserSignupId


	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FRIENDS_AND_FOLLOW_LIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 27-SEPT-2016
-- Description:	TO GET THE FRIENDS LIST
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_FRIENDS_AND_FOLLOW_LIST]
	-- Add the parameters for the stored procedure here
	@p_user_id int,
	@p_var_start int,
	@p_var_end int
AS




BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

			;WITH USERLIST AS(
			SELECT 
			
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID FROM USER_PROFILE PR
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			WHERE SENTBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
			UNION ALL 
			
			SELECT 
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID FROM USER_PROFILE PR
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			WHERE RECEIVEDBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			UNION ALL 
		    SELECT 
			PR.USER_ID,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,SI.SIGNUP_EMAIL,PR.SIGNUP_ID
		    FROM USER_FOLLOWERS UR

		    INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
			INNER JOIN SIGNUP_INFO SI ON SI.ID=PR.SIGNUP_ID
		    WHERE UR.DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_user_id
			),
			 TOEmailUSer AS 
			(
				SELECT 
				TO_USER_ID,EMAIL_DATE,
				ROW_NUMBER() OVER (PARTITION BY TO_USER_ID ORDER BY EMAIL_DATE DESC) AS ROWNUM
				FROM USER_EMAILS UE WHERE FROM_USER_ID=@p_user_id

			),
			FromEmailUSer AS(
			SELECT 
				FROM_USER_ID,EMAIL_DATE,
				ROW_NUMBER() OVER (PARTITION BY FROM_USER_ID ORDER BY EMAIL_DATE DESC) AS ROWNUM
				FROM USER_EMAILS UE WHERE TO_USER_ID=@p_user_id
			),
			USERLISTALLCONNECT AS
			(
			select TO_USER_ID AS USER_ID,EMAIL_DATE from TOEmailUSer  WHERE ROWNUM = 1 
			UNION  ALL 
			select FROM_USER_ID AS USER_ID,EMAIL_DATE from FromEmailUSer  WHERE ROWNUM = 1 
			),
			USERLISTALLCONNECT2 AS
			(
			SELECT 
				USER_ID,EMAIL_DATE,
				ROW_NUMBER() OVER (PARTITION BY USER_ID ORDER BY EMAIL_DATE DESC) AS ROWNUM
				FROM USERLISTALLCONNECT UE 
			),
			USERLISTALLCONNECT3 AS
			(
			SELECT 
				* FROM USERLISTALLCONNECT2  WHERE ROWNUM = 1 
			),

			USERLISTALLCONNECT_ALL AS
			(
				select UL.USER_ID,
				UL.FIRST_NAME,
				UL.LAST_NAME,
				UL.PROFILE_PHOTO,
				UL.SIGNUP_EMAIL,
				UL.SIGNUP_ID,
				ULL.EMAIL_DATE,
				ROW_NUMBER() OVER (ORDER BY ULL.EMAIL_DATE DESC,UL.USER_ID DESC) AS ID
				--ROW_NUMBER() OVER (PARTITION BY ULL.EMAIL_DATE DESC,UL.USER_ID DESC) AS ID 
				FROM USERLIST UL 
				LEFT JOIN  
				USERLISTALLCONNECT3 ULL ON UL.USER_ID=ULL.USER_ID

			)

			select * from USERLISTALLCONNECT_ALL where ID BETWEEN @p_var_start AND @p_var_end
END
 
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FRIENDS_LIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 27-SEPT-2016
-- Description:	TO GET THE FRIENDS LIST
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_FRIENDS_LIST]
	-- Add the parameters for the stored procedure here
	@p_user_id int
AS

DECLARE
@p_friends_sent_count int,
@p_friends_received_count int,
@p_friends_total int

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
			SELECT TOP 10 1 AS TABLE0, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			WHERE SENTBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
			UNION ALL 
			
			SELECT TOP 10 1 AS TABLE0, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			WHERE RECEIVEDBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
   	 --TO SELECT FOLLOWing LIST
			
			--SELECT TOP 6 1 AS TABLE1, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME FROM USER_PROFILE PR
			--INNER JOIN USER_FOLLOWERS UF ON PR.USER_ID = UF.USER_ID
			--WHERE UF.USER_ID = @p_user_id AND UF.DELETE_FLAG =0
		
		     SELECT 1 AS TABLE1,PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME 
		      FROM USER_FOLLOWERS UR
		      INNER JOIN USER_PROFILE PR ON UR.USER_ID = PR.USER_ID
		     WHERE UR.DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_user_id
		
	  ---TO SELECT COUNT OF FRIENDS
		    SELECT @p_friends_sent_count=COUNT(PR.USER_ID) FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			WHERE FR.RECEIVEDBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			
	   ---TO SELECT COUNT OF FRIENDS
			 
			SELECT @p_friends_received_count= COUNT(PR.USER_ID)  FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			WHERE FR.SENTBY_USER_ID = @p_user_id AND FR.REQUEST_STATUS =1
			 
	        SELECT @p_friends_total=@p_friends_sent_count+@p_friends_received_count
		    SELECT 1 AS TABLE2 ,@p_friends_total as FRIENDS_COUNT
		 
		 
		---TO SELECT COUNT OF FOLLOWing
			--SELECT 1 AS TABLE3, COUNT(PR.USER_ID) AS FOLLOWING_COUNT FROM USER_PROFILE PR
			--INNER JOIN USER_FOLLOWERS UF ON PR.USER_ID = UF.FOLLOWER_USER_ID
			--WHERE UF.USER_ID = @p_user_id AND UF.DELETE_FLAG =0
			
			SELECT 1 AS TABLE3, COUNT(FOLLOWER_USER_ID) AS FOLLOWING_COUNT from USER_FOLLOWERS where DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_user_id
END
 
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetAnotherUserData]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Avinash Chandanshive>
-- Create date: <19-sep,,>
-- Description:	<get search user,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_GetAnotherUserData]
	-- Add the parameters for the stored procedure here
@p_var_searchusersignupid int,
@p_var_MainUser int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


	
	DECLARE 
	@SearchUSER_ID BIGINT,
	@USER_FRIENDCOUNT BIGINT,
	@USER_FOLLOWING BIGINT,
	@USER_FOLLOWER BIGINT,
	@IS_FRIEND_STAT INT,
	@MainUSER_ID BIGINT,
	@var_count1 INT,
	@var_Count2 INT,
	@Reqst_Stat INT,
	@Follow_Stat INT,
	@Follow_Stat1 INT,
	@Follow_Stat2 INT
	
	
	


	SET NOCOUNT ON;




		SELECT @MainUSER_ID = USER_ID
		FROM USER_PROFILE WHERE 
		SIGNUP_ID=@p_var_MainUser;

		SELECT @SearchUSER_ID = USER_ID
		FROM USER_PROFILE WHERE 
		SIGNUP_ID=@p_var_searchusersignupid;
	
		--SELECT @SearchUSER_ID = USER_ID
		--FROM USER_PROFILE WHERE 
		--SIGNUP_ID=@p_var_searchusersignupid;

	
		--SELECT @USER_FRIENDCOUNT=COUNT(*)
		--FROM [dbo].[FRIENDS_REQUESTS]  
		--where SENTBY_USER_ID=@SearchUSER_ID 
		--AND REQUEST_STATUS=1

		--SELECT @IS_FRIEND_STAT=REQUEST_STATUS
		--FROM [dbo].[FRIENDS_REQUESTS]  
		--where SENTBY_USER_ID = @MainUSER_ID AND RECEIVEDBY_USER_ID=@SearchUSER_ID
			

		--SELECT @USER_FOLLOWING=COUNT(*) 
		--FROM 
		--[dbo].[USER_FOLLOWERS] WHERE 
		--USER_ID=@SearchUSER_ID  
		--AND DELETE_FLAG = 0


			--SELECT @USER_FOLLOWER=COUNT(*) 
			--FROM 
			--[dbo].[USER_FOLLOWERS] WHERE 
			--FOLLOWER_USER_ID=@SearchUSER_ID  
			--AND DELETE_FLAG = 0


			;WITH RECORD AS (
			SELECT PROFILE_PHOTO,
				USER_COVER_PHOTO ,
				FIRST_NAME ,
				LAST_NAME
				FROM [dbo].[USER_PROFILE]
				WHERE USER_ID=@SearchUSER_ID
				AND DELETE_FLAG = 0
			)

	

			SELECT ISNULL(PROFILE_PHOTO,'') AS PROFILE_PHOTO,
			ISNULL(USER_COVER_PHOTO,'') AS USER_COVER_PHOTO,
			FIRST_NAME,
			LAST_NAME,
			@USER_FRIENDCOUNT AS USER_FRIENDCOUNT,
			@USER_FOLLOWING AS USER_FOLLOWING,
			ISNULL(@IS_FRIEND_STAT,'') AS IS_FRIEND_STAT,
			@USER_FOLLOWER  AS USER_FOLLOWER FROM RECORD AS USER_FOLLOWER


			SELECT @var_count1=Count(*)
			FROM [dbo].[FRIENDS_REQUESTS] WHERE
			(RECEIVEDBY_USER_ID=@MainUSER_ID AND SENTBY_USER_ID=@SearchUSER_ID  AND REQUEST_STATUS<>2)
			OR (RECEIVEDBY_USER_ID=@SearchUSER_ID AND SENTBY_USER_ID=@MainUSER_ID AND REQUEST_STATUS<>2)


			SELECT TOP 1 @Reqst_Stat=REQUEST_STATUS  
			FROM [dbo].[FRIENDS_REQUESTS] WHERE
			(RECEIVEDBY_USER_ID=@MainUSER_ID AND SENTBY_USER_ID=@SearchUSER_ID AND REQUEST_STATUS<>2)
			OR (RECEIVEDBY_USER_ID=@SearchUSER_ID AND SENTBY_USER_ID=@MainUSER_ID AND REQUEST_STATUS<>2)



			SELECT @var_Count2=Count(*)
			FROM [dbo].[FRIENDS_REQUESTS] WHERE
			RECEIVEDBY_USER_ID=@SearchUSER_ID AND SENTBY_USER_ID=@MainUSER_ID  AND REQUEST_STATUS<>2
			
			
			select @Follow_Stat1=COUNT(*) FROM [dbo].[USER_FOLLOWERS] WHERE FOLLOWER_USER_ID=@MainUSER_ID
			AND USER_ID=@SearchUSER_ID AND DELETE_FLAG=0

			select @Follow_Stat2=COUNT(*) FROM [dbo].[USER_FOLLOWERS] WHERE FOLLOWER_USER_ID=@SearchUSER_ID
			AND USER_ID=@MainUSER_ID AND DELETE_FLAG=0
	
			--select @Follow_Stat = isnull(@Follow_Stat2,0) --+ isnull(@Follow_Stat2,0)
			select @var_count1 as Stat,@var_count2 As Stat2,isnull(@Reqst_Stat,3)  as Reqst_Stat,@Follow_Stat1 AS Follow_Stat,@Follow_Stat2 AS Follower_Stat
    -- Insert statements for procedure here
	
END


GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GETEmailForUser]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_GETEmailForUser] 
	-- Add the parameters for the stored procedure here
	@p_Main_UserID BIGINT,
	@p_Search_UserID BIGINT,
	@p_Start INT,
	@p_END INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	;WITH RECORD AS(
	SELECT convert(varchar(100),EMAIL_DATE) as EMAIL_DATE,
	EMAIL_BODY,
	EMAIL_SUBJECT,
	FROM_USER_ID,
	TO_USER_ID,
	UP.FIRST_NAME,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO,
	EMAILIDNUMBER,
	
	ROW_NUMBER() OVER (ORDER BY EMAIL_DATE DESC) AS ID 
	FROM [dbo].[USER_EMAILS] INNER JOIN USER_PROFILE UP
	ON UP.USER_ID=FROM_USER_ID WHERE (FROM_USER_ID=@p_Main_UserID AND TO_USER_ID=@p_Search_UserID)
	OR (TO_USER_ID=@p_Main_UserID AND FROM_USER_ID=@p_Search_UserID)
	)
	SELECT * FROM RECORD WHERE ID BETWEEN @p_Start AND @p_END
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetInbox]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_GetInbox] 
	-- Add the parameters for the stored procedure here
@p_Main_UserID BIGINT,
@P_start INT,
@p_End INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[USER_EMAILS] SET IS_SEEN = 1 WHERE TO_USER_ID=@p_Main_UserID


	;WITH RECORD AS(
	SELECT convert(varchar(100),EMAIL_DATE) as EMAIL_DATE,
	EMAIL_BODY,
	EMAIL_SUBJECT,
	FROM_USER_ID,
	TO_USER_ID,
	UP.FIRST_NAME,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO,
	EMAILIDNUMBER,
	
	ROW_NUMBER() OVER (ORDER BY EMAIL_DATE DESC) AS ID ,
	SI.SIGNUP_EMAIL
	FROM [dbo].[USER_EMAILS] 
	INNER JOIN USER_PROFILE UP ON UP.USER_ID = FROM_USER_ID
	INNER JOIN SIGNUP_INFO SI ON UP.SIGNUP_ID =SI.ID
	 WHERE (TO_USER_ID=@p_Main_UserID )
	)
	SELECT * FROM RECORD WHERE ID BETWEEN @p_Start AND @p_END


END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GetSentBox]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_GetSentBox]
	-- Add the parameters for the stored procedure here
@p_Main_UserID BIGINT,
@P_start INT,
@p_End INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	;WITH RECORD AS(
	SELECT convert(varchar(100),EMAIL_DATE) as EMAIL_DATE,
	EMAIL_BODY,
	EMAIL_SUBJECT,
	FROM_USER_ID,
	TO_USER_ID,
	UP.FIRST_NAME,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO,
	EMAILIDNUMBER,
	
	ROW_NUMBER() OVER (ORDER BY EMAIL_DATE DESC) AS ID 
	FROM [dbo].[USER_EMAILS] INNER JOIN USER_PROFILE UP
	ON UP.USER_ID=TO_USER_ID WHERE (FROM_USER_ID=@p_Main_UserID )
	)
	SELECT * FROM RECORD WHERE ID BETWEEN @p_Start AND @p_END


END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_GETUserProfileData]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avinash Chandanshive>
-- Create date: <7/12/2016>
-- Description:	<To Get User Profile Data>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_GETUserProfileData] 
	-- Add the parameters for the stored procedure here
	@p_var_SignUpID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 BEGIN TRY

	;WITH INFOTABLE AS(
	SELECT	SIGNUP_ID,
			USER_ID,
			USERTYPE_ID,
			ROLE_ID,
			ISNULL(SI.SIGNUP_EMAIL,'') AS SIGNUP_EMAIL,
			ISNULL(USER_NAME,'') AS USER_NAME,
			ISNULL(USER_PWD,'') AS USER_PWD,
			ISNULL(PROFILE_PHOTO,'') AS PROFILE_PHOTO,
			ISNULL(FIRST_NAME,'') AS FIRST_NAME,
			ISNULL(LAST_NAME,'') AS LAST_NAME,
			ISNULL(USER_TITLE,'') AS USER_TITLE,
			Convert(varchar(60),ISNULL(DATE_OF_BIRTH,''))  AS DATE_OF_BIRTH,
			ISNULL(CAR_IND_TYPE,'') AS CAR_IND_TYPE,
			ISNULL(JOB_TITLE,'') AS JOB_TITLE,
			ISNULL(COMPANY_NAME,'') AS COMPANY_NAME,
			ISNULL(USER_BIO,'') AS USER_BIO,
			ISNULL(CREATED_DATE,'') AS CREATED_DATE,
			ISNULL(MODIFIED_DATE,'') AS MODIFIED_DATE,
			DELETE_FLAG FROM USER_PROFILE INNER JOIN SIGNUP_INFO SI ON SI.ID=USER_PROFILE.SIGNUP_ID
		    WHERE SIGNUP_ID = @p_var_SignUpID AND DELETE_FLAG=0)

	
			SELECT DISTINCT ISNULL(STUFF((SELECT CAST( TM.TAG_KEYWORD AS varchar(50))+ ','  FROM TAGS_MASTER TM INNER JOIN 
			[dbo].[USER_TAGS] UT ON UT.TAGS_ID=TM.ID AND UT.USER_ID=IT.USER_ID
            FOR XML PATH(''), TYPE
            ).value('.','VARCHAR(MAX)'),1,0,'') ,'') as TAGS,

			ISNULL(STUFF((SELECT CAST( UE.EXPERTISE_AREA_ID AS varchar(50))+ ','  FROM USER_EXPERTISE UE 
			WHERE UE.USER_ID=IT.USER_ID
			
            FOR XML PATH(''), TYPE
            ).value('.','VARCHAR(MAX)'),1,0,'') ,'') AS EXPERTISE,
			IT.* FROM INFOTABLE IT
			  END TRY
			BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH 
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_LASTMOOD]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 17-sept-2016
-- Description:	to get the last mood
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_LASTMOOD]
	-- Add the parameters for the stored procedure here
	@p_user_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MM.ID,MM.MOODS_IMG_URL from dbo.MOODS_MASTER MM
	INNER JOIN USER_MOOD_FORDAY UMR ON UMR.MOOD = MM.ID
	WHERE UMR.USER_ID = @p_user_id;
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodForDay]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 14-SEPT-16
-- Description:	existence of mood in a day
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_MoodForDay] 
	-- Add the parameters for the stored procedure here
	@p_user_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UMF.MOOD,UMF.MOOD_DATE FROM dbo.USER_MOOD_FORDAY UMF
	left join USER_PROFILE UP ON UP.USER_ID = UMF.USER_ID
	WHERE UMF.USER_ID = @p_user_id ;
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodMaster]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_MoodMaster] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID, MOODS_DESCRIPTION FROM [DBO].[MOODS_MASTER] ORDER BY ID ASC
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MoodsList]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_MoodsList]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MM.ID ,MM.MOODS_IMG_URL,MM.MOODS_DESCRIPTION FROM  dbo.MOODS_MASTER MM
	WHERE MM.ID != 1;
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_NonFriendUser]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_NonFriendUser]
	-- Add the parameters for the stored procedure here
@UserSignUp_ID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 

	@USERID BIGINT

    -- Insert statements for procedure here
	SELECT @USERID=USER_ID FROM USER_PROFILE 
	WHERE SIGNUP_ID=@UserSignUp_ID

		;WITH RECORD AS(
	SELECT SENTBY_USER_ID  AS USERID 
	FROM [dbo].[FRIENDS_REQUESTS] WHERE 
	(RECEIVEDBY_USER_ID=@USERID) AND REQUEST_STATUS<>2
	UNION
	SELECT RECEIVEDBY_USER_ID AS USERID 
	FROM [dbo].[FRIENDS_REQUESTS] WHERE 
	SENTBY_USER_ID=@USERID AND REQUEST_STATUS<>2
	)

		select DISTINCT TOP 5 1 As Suggestion , * FROM 
		 [dbo].[USER_PROFILE] 
		WHERE USER_ID NOT 
		IN(SELECT USERID FROM RECORD) 
		AND USER_ID <> @USERID ORDER BY USER_ID DESC
	--SELECT * FROM RECORD
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ONLY_FRIENDS]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Siddharam
-- Create date: 05-oct-2016
-- Description:	to select only frieds list
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_ONLY_FRIENDS]
	-- Add the parameters for the stored procedure here
     @p_signup_id int
AS

DECLARE
@p_UserID INT

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_UserID = USER_ID FROM USER_PROFILE WHERE SIGNUP_ID=@p_signup_id
	     
	 SELECT DISTINCT 1 AS TABLE0,PR.SIGNUP_ID, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME,
		    PR.JOB_TITLE,convert(char(13),PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		    PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL,
	       ISNULL(STUFF((SELECT CAST( CM.Contact_name AS varchar(50))+ ','  from USER_RELATIONSHIP UR 
	       INNER JOIN Conatct_Master CM ON UR.RELATIONSHIP_ID = CM.Contact_Id
	       WHERE PR.SIGNUP_ID = UR.RECEVIER_ID
           FOR XML PATH(''), TYPE).value('.','VARCHAR(MAX)'),1,0,'') ,'') as RELATION_NAME
		    FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.RECEIVEDBY_USER_ID
			INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
			INNER JOIN USER_RELATIONSHIP UR ON (PR.SIGNUP_ID = UR.RECEVIER_ID OR PR.SIGNUP_ID = UR.SENDER_ID)
			WHERE SENTBY_USER_ID = @p_UserID AND FR.REQUEST_STATUS = 1 AND UR.RELATIONSHIP_ID =3
			AND (FR.SENTBY_USER_ID = @p_UserID OR FR.RECEIVEDBY_USER_ID = @p_UserID)
			
			UNION ALL 
			
		   SELECT DISTINCT 1 AS TABLE0,PR.SIGNUP_ID, PR.FIRST_NAME,PR.LAST_NAME,PR.PROFILE_PHOTO,PR.USER_NAME,
		   PR.JOB_TITLE,convert(char(13),PR.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		   PR.CAR_IND_TYPE,SI.SIGNUP_EMAIL,
	       ISNULL(STUFF((SELECT CAST( CM.Contact_name AS varchar(50))+ ','  from USER_RELATIONSHIP UR 
	       INNER JOIN Conatct_Master CM ON UR.RELATIONSHIP_ID = CM.Contact_Id
	       WHERE PR.SIGNUP_ID = UR.RECEVIER_ID
           FOR XML PATH(''), TYPE).value('.','VARCHAR(MAX)'),1,0,'') ,'') as RELATION_NAME
		    FROM USER_PROFILE PR
			INNER JOIN FRIENDS_REQUESTS FR ON PR.USER_ID = FR.SENTBY_USER_ID
			INNER JOIN SIGNUP_INFO SI ON PR.SIGNUP_ID = SI.ID
			INNER JOIN USER_RELATIONSHIP UR ON (PR.SIGNUP_ID = UR.RECEVIER_ID OR PR.SIGNUP_ID = UR.SENDER_ID)
			WHERE SENTBY_USER_ID = @p_UserID AND FR.REQUEST_STATUS = 1 AND UR.RELATIONSHIP_ID =3
			AND (FR.SENTBY_USER_ID = @p_UserID OR FR.RECEIVEDBY_USER_ID = @p_UserID)   
	     
	     
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_OptionView]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_OptionView] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

SELECT * FROM [dbo].[POST_VIEW_OPTION] ORDER BY POSTVIEW_OPTION_ID 
	
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforProfile]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PostforProfile]
	-- Add the parameters for the stored procedure here
	@p_var_SignupID BIGINT,
	@p_var_Start INT,
	@p_var_End INT,
	@p_var_Expertise INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_var_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_var_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_SignupID

	if @p_var_Expertise= -1 OR @p_var_Expertise =1

	BEGIN
	;WITH USERIDRECORD1 AS (SELECT SENTBY_USER_ID  AS USERID, 
	1 AS TYPE  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=26) 
		AND REQUEST_STATUS=1
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID  ,1 AS TYPE 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=26 
		AND REQUEST_STATUS=1
		UNION
		select USER_ID  AS USERID, 
		2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID=26 AND DELETE_FLAG=0
		UNION
		SELECT 26 AS USERID,3 AS TYPE  ) --Self)
		,
		UserCount AS 
		( 
		 SELECT COUNT(USERID) USerCount,USERID FROM USERIDRECORD1 GROUP BY USERID
		),
		SharePostUSers AS 
		(

			SELECT POST_USER_ID, 4 AS TYPE FROM SHARE_POST SP
			LEFT JOIN UserCount UC ON SP.Post_USER_ID = UC.USERID
			WHERE USER_ID = 26 AND ISNULL(UC.USerCount,0) = 0
		),
		USERIDRECORD AS
		(
			--SELECT USERID,TYPE FROM USERIDRECORD1
			--UNION ALL
			SELECT POST_USER_ID,TYPE FROM SharePostUSers
        ),
	Share_Posts AS 
	(
	SELECT POST_USER_ID AS USERID ,POST_ID  FROM SHARE_POST WHERE USER_ID = 26
	)

	, MESSAGECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPC .POST_ID) AS MSGCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_COMMENTS] UPC 
	ON UPC.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD1 URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	)  ,

	 LIKECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPL .POST_ID) AS LKCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_LIKE] UPL 
	ON UPL.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD1 URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	),

		DISLIKECOUNT AS(
		select  DISTINCT UP.POST_ID,COUNT(UPDL .POST_ID) AS DLKCOUNT FROM 
		USER_POSTS UP 
		LEFT JOIN [dbo].[USER_POSTS_DISLIKE] UPDL 
		ON UPDL.POST_ID=UP.POST_ID
		LEFT JOIN USERIDRECORD1 URR 
		ON URR.USERID=UP.USER_ID
		 GROUP BY UP.POST_ID
	),

	 RECORD AS (
	SELECT  DISTINCT UP.POST_ID,
	URR.USERID as USER_ID,
	UPP.SIGNUP_ID,
	UP.POST_DATE,
	UPP.FIRST_NAME,
	UPP.LAST_NAME,
	UPP.PROFILE_PHOTO,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	UP.POST_WEBSITE_LINK,
	UP.POST_VIDEO_URL,
	URR.TYPE,
	CASE WHEN URR.TYPE = 1 THEN 
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 2 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 3 OR  URR.TYPE = 4  THEN 1 END
	END	END AS SHOWPOST,
	MSGCOUNT,
	LKCOUNT,
	DLKCOUNT,
	UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID

/*Type = 1 ->  PostViewoption -> 1,3,4,5
  Type = 2 ->  PostView -> 1,4,5
  Type = 3 -> All
  */
	FROM [dbo].[USER_POSTS] UP
	INNER JOIN USER_PROFILE UPP
	ON UPP.USER_ID=UP.USER_ID
	INNER JOIN USERIDRECORD1 URR 
	ON URR.USERID=UP.USER_ID  
	INNER JOIN MESSAGECOUNT MSG ON MSG.POST_ID=UP.POST_ID 
	INNER JOIN LIKECOUNT LKC ON LKC.POST_ID=UP.POST_ID
	INNER JOIN DISLIKECOUNT DLKC ON DLKC.POST_ID=UP.POST_ID
	LEFT JOIN [dbo].[REMOVE_POST] RP ON RP.POST_ID=UP.POST_ID AND RP.USER_ID=@p_var_UserID
	--LEFT JOIN Share_Posts SP ON SP.POST_ID=UP.POST_ID AND SP.USERID=UP.USER_ID

	 WHERE  UP.POST_IS_PUBLISH=1 AND RP.POST_ID IS NULL --AND SP.USER_ID=@p_var_UserID
	
	),
	
	
	
	 RECORD2 AS (
	SELECT  DISTINCT UP.POST_ID,
	URR.USERID as USER_ID,
	UPP.SIGNUP_ID,
	UP.POST_DATE,
	UPP.FIRST_NAME,
	UPP.LAST_NAME,
	UPP.PROFILE_PHOTO,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	UP.POST_WEBSITE_LINK,
	UP.POST_VIDEO_URL,
	URR.TYPE,
	CASE WHEN URR.TYPE = 1 THEN 
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 2 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 3 OR  URR.TYPE = 4  THEN 1 END
	END	END AS SHOWPOST,
	MSGCOUNT,
	LKCOUNT,
	DLKCOUNT,
	UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID

/*Type = 1 ->  PostViewoption -> 1,3,4,5
  Type = 2 ->  PostView -> 1,4,5
  Type = 3 -> All
  */
	FROM [dbo].[USER_POSTS] UP
	INNER JOIN USER_PROFILE UPP
	ON UPP.USER_ID=UP.USER_ID
	INNER JOIN USERIDRECORD1 URR 
	ON URR.USERID=UP.USER_ID  
	INNER JOIN MESSAGECOUNT MSG ON MSG.POST_ID=UP.POST_ID 
	INNER JOIN LIKECOUNT LKC ON LKC.POST_ID=UP.POST_ID
	INNER JOIN DISLIKECOUNT DLKC ON DLKC.POST_ID=UP.POST_ID
	LEFT JOIN [dbo].[REMOVE_POST] RP ON RP.POST_ID=UP.POST_ID AND RP.USER_ID=@p_var_UserID
	--LEFT JOIN Share_Posts SP ON SP.POST_ID=UP.POST_ID AND SP.USERID=UP.USER_ID

	 WHERE  UP.POST_IS_PUBLISH=1 AND RP.POST_ID IS NULL --AND SP.USER_ID=@p_var_UserID
	
	),
	
	
	
	 SHOWRECORD AS( 
	SELECT *,ROW_NUMBER() 
	OVER (ORDER BY RECORD.POST_ID DESC,POST_DATE DESC) AS ID FROM RECORD WHERE
	  SHOWPOST=1
	)

	--SELECT * FROM RECORD
	SELECT DISTINCT SHOWRECORD.POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	 SIGNUP_ID,
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 MSGCOUNT,
	 LKCOUNT,
	 DLKCOUNT,
	 ISNULL(POST_WEBSITE_LINK,'') AS POST_WEBSITE_LINK,
	 FIRST_NAME,
	 LAST_NAME,
	 PROFILE_PHOTO,
	 POST_IS_PUBLISH,
	 TYPE,
	 ISNULL(POST_VIDEO_URL,'') AS POST_VIDEO_URL
	 FROM SHOWRECORD 
	 
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End

	 END
	 ELSE
	 BEGIN 


	 ;WITH USERIDRECORD AS (

	SELECT SENTBY_USER_ID  AS USERID, 
	1 AS TYPE  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_var_UserID) 
		AND REQUEST_STATUS=1
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID  ,1 AS TYPE 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_var_UserID 
		AND REQUEST_STATUS=1
		UNION
		select USER_ID  AS USERID, 
		2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID=@p_var_UserID AND DELETE_FLAG=0
		UNION
		SELECT @p_var_UserID AS USERID,3 AS TYPE   --Self
	
	)

	, MESSAGECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPC .POST_ID) AS MSGCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_COMMENTS] UPC 
	ON UPC.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	)  ,

	 LIKECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPL .POST_ID) AS LKCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_LIKE] UPL 
	ON UPL.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	),

		DISLIKECOUNT AS(
		select  DISTINCT UP.POST_ID,COUNT(UPDL .POST_ID) AS DLKCOUNT FROM 
		USER_POSTS UP 
		LEFT JOIN [dbo].[USER_POSTS_DISLIKE] UPDL 
		ON UPDL.POST_ID=UP.POST_ID
		LEFT JOIN USERIDRECORD URR 
		ON URR.USERID=UP.USER_ID
		 GROUP BY UP.POST_ID
	),

	 RECORD AS (
	SELECT  DISTINCT UP.POST_ID,
	URR.USERID as USER_ID,
	UPP.SIGNUP_ID,
	UP.POST_DATE,
	UPP.FIRST_NAME,
	UPP.LAST_NAME,
	UPP.PROFILE_PHOTO,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	UP.POST_WEBSITE_LINK,
	UP.POST_VIDEO_URL,
	URR.TYPE,
	CASE WHEN URR.TYPE = 1 THEN 
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 2 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 3 THEN 1 END
	END	END AS SHOWPOST,
	MSGCOUNT,
	LKCOUNT,
	DLKCOUNT,
	UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID
 
 /*Type = 1 ->  PostViewoption -> 1,3,4,5
  Type = 2 ->  PostView -> 1,4,5
  Type = 3 -> All
  */
	FROM [dbo].[USER_POSTS] UP
	INNER JOIN USER_PROFILE UPP
	ON UPP.USER_ID=UP.USER_ID
	INNER JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID  
	INNER JOIN MESSAGECOUNT MSG ON MSG.POST_ID=UP.POST_ID 
	INNER JOIN LIKECOUNT LKC ON LKC.POST_ID=UP.POST_ID
	INNER JOIN DISLIKECOUNT DLKC ON DLKC.POST_ID=UP.POST_ID
	INNER JOIN USER_POST_EXPERTISE UPE ON UPE.USER_POSTS_POST_ID=UP.POST_ID
	LEFT JOIN [dbo].[REMOVE_POST] RP ON RP.POST_ID=UP.POST_ID AND RP.USER_ID=@p_var_UserID
	--LEFT JOIN [dbo].[SHARE_POST] SP ON SP.POST_ID=UP.POST_ID AND SP.USER_ID=@p_var_UserID
	 WHERE  UP.POST_IS_PUBLISH=1 AND 
	 RP.POST_ID IS NULL AND
	 UPE.EXPERTISE_AREA_ID= @p_var_Expertise
	
	), SHOWRECORD AS( 
	SELECT *,ROW_NUMBER() 
	OVER (ORDER BY RECORD.POST_ID DESC,POST_DATE DESC) AS ID FROM RECORD WHERE
	  SHOWPOST=1
	)

	--SELECT * FROM RECORD
	SELECT DISTINCT SHOWRECORD.POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	 SIGNUP_ID,
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 MSGCOUNT,
	 LKCOUNT,
	 DLKCOUNT,
	 ISNULL(POST_WEBSITE_LINK,'') AS POST_WEBSITE_LINK,
	 FIRST_NAME,
	 LAST_NAME,
	 PROFILE_PHOTO,
	 POST_IS_PUBLISH,
	 TYPE,
	  ISNULL(POST_VIDEO_URL,'') AS POST_VIDEO_URL
	 FROM SHOWRECORD 
	 
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End

	 END
	 
END




GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforProfileForSelectedUser]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PostforProfileForSelectedUser]
	-- Add the parameters for the stored procedure here
	@p_var_SignupID BIGINT,
	@p_var_Start INT,
	@p_var_End INT,
	@p_var_MainUserSignupID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_var_UserID BIGINT,
	@p_var_MainUserID BIGINT,
	@p_Relation BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_var_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_SignupID

	SELECT @p_var_MainUserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_MainUserSignupID



 
		SELECT @p_Relation = 1  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		((RECEIVEDBY_USER_ID=@p_var_UserID AND 
		SENTBY_USER_ID=@p_var_MainUserID) 

		OR (SENTBY_USER_ID =@p_var_UserID AND 

		RECEIVEDBY_USER_ID=@p_var_MainUserID))
		AND REQUEST_STATUS=1
	
		select 
		@p_Relation=2  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID= @p_var_MainUserID AND 
		USER_ID=@p_var_UserID
		AND DELETE_FLAG=0
 
		;WITH USERIDRECORD AS (
	--		SELECT SENTBY_USER_ID  AS USERID, 
	--1 AS TYPE  --Friend
	--	FROM [dbo].[FRIENDS_REQUESTS] WHERE 
	--	((RECEIVEDBY_USER_ID=@p_var_UserID AND 
	--	SENTBY_USER_ID=@p_var_MainUserID) 

	--	OR (SENTBY_USER_ID =@p_var_UserID AND 

	--	RECEIVEDBY_USER_ID=@p_var_MainUserID))
	--	AND REQUEST_STATUS=1
	--	UNION
	--	select USER_ID  AS USERID, 
	--	2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
	--	WHERE FOLLOWER_USER_ID=@p_var_UserID AND 
	--	USER_ID=@p_var_MainUserID
	--	AND DELETE_FLAG=0
	--	UNION 
		SELECT @p_var_UserID AS USERID,3 AS TYPE 
	)

	, MESSAGECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPC .POST_ID) AS MSGCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_COMMENTS] UPC 
	ON UPC.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	),

	 LIKECOUNT AS(
	select DISTINCT UP.POST_ID,COUNT(UPL .POST_ID) AS LKCOUNT FROM 
	USER_POSTS UP 
	LEFT JOIN [dbo].[USER_POSTS_LIKE] UPL 
	ON UPL.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID
	 GROUP BY UP.POST_ID
	),

		DISLIKECOUNT AS(
		select  DISTINCT UP.POST_ID,COUNT(UPDL .POST_ID) AS DLKCOUNT FROM 
		USER_POSTS UP 
		LEFT JOIN [dbo].[USER_POSTS_DISLIKE] UPDL 
		ON UPDL.POST_ID=UP.POST_ID
		LEFT JOIN USERIDRECORD URR 
		ON URR.USERID=UP.USER_ID
		 GROUP BY UP.POST_ID
	),

	 RECORD AS (
	SELECT  DISTINCT UP.POST_ID,
	URR.USERID as USER_ID,
	upp.SIGNUP_ID,
	UP.POST_DATE,
	UPP.FIRST_NAME,
	UPP.LAST_NAME,
	UPP.PROFILE_PHOTO,
	isnull(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	UP.POST_HEADLINE_2,
	UP.POST_PHOTO_URL ,
	UP.POST_HAS_PHOTO,
	UP.POST_IS_PUBLISH,
	UP.POST_WEBSITE_LINK,
	UP.POST_VIDEO_URL,
	URR.TYPE,

	CASE WHEN @p_Relation = 1 THEN 
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	@p_Relation = 2 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	URR.TYPE = 3 THEN 1 END
	END	END AS SHOWPOST,
	MSGCOUNT,
	LKCOUNT,
	DLKCOUNT
	FROM [dbo].[USER_POSTS] UP
	INNER JOIN USER_PROFILE UPP
	ON UPP.USER_ID=UP.USER_ID
	INNER JOIN USERIDRECORD URR 
	ON URR.USERID=UP.USER_ID
	INNER JOIN MESSAGECOUNT MSG ON MSG.POST_ID=UP.POST_ID
	INNER JOIN LIKECOUNT LKC ON LKC.POST_ID=UP.POST_ID
	INNER JOIN DISLIKECOUNT DLKC ON DLKC.POST_ID=UP.POST_ID
	LEFT JOIN [dbo].[REMOVE_POST] RP ON RP.POST_ID=UP.POST_ID AND RP.USER_ID=@p_var_UserID
	 WHERE  UP.POST_IS_PUBLISH=1  AND RP.POST_ID IS NULL 
	)
	,RECORDLast AS(
	SELECT *, ROW_NUMBER() 
	OVER (ORDER BY RECORD.POST_ID DESC,POST_DATE DESC) AS ID FROM RECORD
	WHERE SHOWPOST=1
	
	)


	SELECT DISTINCT RECORDLast.POST_ID,ID,
	 USER_ID,
	 CONVERT(VARCHAR(10),POST_DATE,110) AS POST_DATE,
	
	 ISNULL(POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 POST_HEADLINE_2,
	 POST_PHOTO_URL,
	 MSGCOUNT,
	 SIGNUP_ID,
	 LKCOUNT,
	 DLKCOUNT,
	 SHOWPOST,
	 ISNULL(POST_WEBSITE_LINK,'') AS POST_WEBSITE_LINK,
	 FIRST_NAME,
	 LAST_NAME,
	 PROFILE_PHOTO,
	 POST_IS_PUBLISH,
	 TYPE,
	  ISNULL(POST_VIDEO_URL,'') AS POST_VIDEO_URL,
	  @p_Relation AS  RELATION 
	 FROM RECORDLast 
	 
	 WHERE  ID BETWEEN @p_var_Start AND @p_var_End

	 
END


GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PostforSELECTEDWord]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PostforSELECTEDWord]
	-- Add the parameters for the stored procedure here
	@p_var_Search varchar(50),
	@p_var_Start INT,
	@p_var_End INT,
	@p_var_Current_SignUpID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_var_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_var_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_var_Current_SignUpID

;WITH USERIDRECORD AS (

	SELECT SENTBY_USER_ID  AS USERID, 
	1 AS TYPE  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_var_UserID) 
		AND REQUEST_STATUS=1
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID  ,1 AS TYPE 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_var_UserID 
		AND REQUEST_STATUS=1
		UNION
		select USER_ID  AS USERID, 
		2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID=@p_var_UserID AND DELETE_FLAG=0
		UNION
		SELECT @p_var_UserID AS USERID,3 AS TYPE   --Self
	
	)
	, MESSAGECOUNT AS(
	SELECT DISTINCT UP.POST_ID,COUNT(UPC.POST_ID) AS MSGCOUNT
	FROM [dbo].[USER_POSTS_COMMENTS] UPC
	RIGHT JOIN  USER_POSTS UP ON 
	UP.POST_ID=UPC.POST_ID
	WHERE UP.POST_CONTAINT LIKE '%'+@p_var_Search+'%'
	GROUP BY UP.POST_ID
	),

	 LIKECOUNT AS(
	SELECT DISTINCT UP.POST_ID,COUNT(UPL.POST_ID) AS LKCOUNT
	FROM [dbo].[USER_POSTS_LIKE] UPL
	RIGHT JOIN  USER_POSTS UP ON 
	UP.POST_ID=UPL.POST_ID
	WHERE UP.POST_CONTAINT LIKE '%'+@p_var_Search+'%'
	GROUP BY UP.POST_ID
	),

		DISLIKECOUNT AS(
	SELECT DISTINCT UP.POST_ID,COUNT(UPD.POST_ID) AS DLKCOUNT
	FROM [dbo].[USER_POSTS_DISLIKE] UPD
	RIGHT JOIN  USER_POSTS UP ON 
	UP.POST_ID=UPD.POST_ID
	WHERE UP.POST_CONTAINT LIKE '%'+@p_var_Search+'%'
	GROUP BY UP.POST_ID
	)
	,

	 RECORD_POST AS(
	
	SELECT DISTINCT UP.POST_ID,
	UP.USER_ID,
	CONVERT(VARCHAR(10),UP.POST_DATE,110) AS POST_DATE,
	 ISNULL(UP.POST_HEADLINE_1,'') AS POST_HEADLINE_1,
	 UP.POST_HEADLINE_2,
	 UP.POST_PHOTO_URL,
	 UPF.SIGNUP_ID,
	 
	MSGCOUNT,
	LKCOUNT,
	DLKCOUNT,
	
	 ISNULL(UP.POST_WEBSITE_LINK,'') 
	 AS POST_WEBSITE_LINK,
		
	 UPF.FIRST_NAME,
	 UPF.LAST_NAME,
	 UPF.PROFILE_PHOTO,
	 UP.POST_IS_PUBLISH,
	 ISNULL(POST_VIDEO_URL,'') AS POST_VIDEO_URL,
	 ISNULL(TYPE,0) AS TYPE,
	

	CASE WHEN ISNULL(TYPE,0) = 1 THEN 
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	 ISNULL(TYPE,0)= 2 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	ISNULL(TYPE,0)= 0 THEN
		CASE WHEN UP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	 ISNULL(TYPE,0) = 3 THEN 1 END
	END	END END AS SHOWPOST
	FROM USER_POSTS UP
	INNER JOIN  USER_PROFILE UPF
	ON UPF.USER_ID=UP.USER_ID
	INNER JOIN MESSAGECOUNT UPC 
	ON UPC.POST_ID=UP.POST_ID
	INNER JOIN DISLIKECOUNT UPD
	ON UPD.POST_ID=UP.POST_ID
	INNER JOIN LIKECOUNT UPL ON UPL.POST_ID=UP.POST_ID
	LEFT JOIN USERIDRECORD URR
	ON URR.USERID=UP.USER_ID  
	LEFT JOIN [dbo].[REMOVE_POST] RP ON RP.POST_ID=UP.POST_ID AND RP.USER_ID=@p_var_UserID
	WHERE UP.POST_HEADLINE_2 LIKE '%'+@p_var_Search+'%'
	AND UP.POST_IS_PUBLISH=1 AND RP.POST_ID IS NULL 
	
	),RECORDSHOW AS(
	SELECT *,ROW_NUMBER() 
	OVER (ORDER BY RECORD_POST.POST_ID DESC,POST_DATE DESC) AS ID  FROM RECORD_POST WHERE SHOWPOST=1
	
	)



	SELECT * FROM RECORDSHOW 
	WHERE ID BETWEEN @p_var_Start AND @p_var_End
	


	 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PRELOAD_COUNTCHAT]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 22-OCT-2016
-- Description:	To select the chat count list is not yet seen 
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PRELOAD_COUNTCHAT]
	-- Add the parameters for the stored procedure here
	@p_signup_id int
AS

DECLARE
@p_UserID int
BEGIN


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
    SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE SIGNUP_ID = @p_signup_id
		
    -- Insert statements for procedure here
	SELECT COUNT(*) AS LIST_SEEN_COUNT  FROM USER_CHATS 
	WHERE TO_USER_ID = @p_UserID  AND IS_SEEN IS NULL


	SELECT COUNT(*) AS LIST_SEEN_COUNT_Mail FROM [dbo].[USER_EMAILS]
	WHERE TO_USER_ID=@p_UserID AND IS_SEEN =0
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PreloadDataForUser]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PreloadDataForUser] 
	-- Add the parameters for the stored procedure here
	@p_var_UserSignupId BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @p_var_UserSignupId


		EXEC  USP_SELECT_ExpertiseArea;


		SELECT COUNT(*) AS LIST_SEEN_COUNT 
		FROM [dbo].[FRIENDS_REQUESTS] 
		WHERE 
		RECEIVEDBY_USER_ID = @p_UserID
		 AND 
		REQUEST_SEEN = 0 AND REQUEST_STATUS=0 ;

		EXEC USP_SELECT_FriendRequestList @p_var_UserSignupId

		EXEC USP_SELECT_SuggestionList  @p_var_UserSignupId

END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_PROFILEDATA_USER]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Siddharam
-- Create date: 21-sept-2016
-- Description:	to get profile data 
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_PROFILEDATA_USER]
	-- Add the parameters for the stored procedure here
	@p_user_id int
AS
DECLARE 
@p_friend_count int,
@p_follower_count int,
@p_following_count int,
@p_UserID Bigint,
@p_friend_count1 int,
@p_friend_total int

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT @p_UserID=USER_ID FROM USER_PROFILE
	WHERE SIGNUP_ID=@p_user_id

    SELECT @p_friend_count = COUNT(SENTBY_USER_ID) from FRIENDS_REQUESTS where REQUEST_STATUS =1 AND SENTBY_USER_ID = @p_UserID
    SELECT @p_friend_count1 =  COUNT(RECEIVEDBY_USER_ID) from FRIENDS_REQUESTS where REQUEST_STATUS =1 AND RECEIVEDBY_USER_ID = @p_UserID
    SELECT @p_friend_total =@p_friend_count+@p_friend_count1;
    
    SELECT @p_following_count = COUNT(FOLLOWER_USER_ID) from USER_FOLLOWERS where DELETE_FLAG =0 AND FOLLOWER_USER_ID =@p_UserID
    SELECT @p_follower_count = COUNT(USER_ID) from USER_FOLLOWERS where DELETE_FLAG =0 AND USER_ID =@p_UserID
            
	SELECT 1 as Tabl1,UP.USER_NAME,UP.FIRST_NAME,UP.LAST_NAME,isnull(UP.PROFILE_PHOTO,'') as PROFILE_PHOTO,isnull(UP.USER_COVER_PHOTO,'') AS USER_COVER_PHOTO,@p_friend_total as FRIENDS_COUNT,
	@p_follower_count AS FOLLOWER_COUNT ,@p_following_count AS FOLLOWING_COUNT
	FROM USER_PROFILE UP WHERE UP.USER_ID =@p_UserID
	
	SELECT 1 as Tabl2,FR.RECEIVEDBY_USER_ID,UP.FIRST_NAME,UP.LAST_NAME,isnull(UP.PROFILE_PHOTO,'') as PROFILE_PHOTO FROM USER_PROFILE UP
    INNER JOIN FRIENDS_REQUESTS FR ON UP.USER_ID = FR.SENTBY_USER_ID
    WHERE UP.USER_ID = @p_UserID AND REQUEST_STATUS = 0
	
	SELECT 1 as Tabl3,UR.FOLLOWER_USER_ID,UP.FIRST_NAME,UP.LAST_NAME,isnull(UP.PROFILE_PHOTO,'') as PROFILE_PHOTO from USER_PROFILE UP 
    INNER JOIN USER_FOLLOWERS UR ON UP.USER_ID = UR.USER_ID
    where UR.DELETE_FLAG =0 AND UR.USER_ID = @p_UserID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_RELATION_CONTENT]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_RELATION_CONTENT]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CONTACT_ID,CONTACT_NAME FROM Conatct_Master WHERE CONTACT_ID NOT IN(1,2);
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_RELATIONSHIP_LIST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM 
-- Create date: 04-OCT-2016
-- Description:	GET relationship data
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_RELATIONSHIP_LIST]
	-- Add the parameters for the stored procedure here
	@p_signup_id int,
	@p_receiver_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UR.RELATIONSHIP_ID,CM.Contact_name from USER_RELATIONSHIP UR 
	INNER JOIN Conatct_Master CM ON UR.RELATIONSHIP_ID =CM.Contact_Id
	where ((UR.SENDER_ID = @p_signup_id AND UR.RECEVIER_ID = @p_receiver_id) OR
	(UR.SENDER_ID =@p_receiver_id AND UR.RECEVIER_ID =@p_signup_id));
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEARCH_USERINFO]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		siddharam
-- Create date: 14-oct-2016
-- Description:	to show all search record related to input parameter
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SEARCH_USERINFO]
	-- Add the parameters for the stored procedure here
	@p_var_UserName varchar(30),
	@p_var_UserSignupId BIGINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE SIGNUP_ID = @p_var_UserSignupId
	
	SELECT  UP.SIGNUP_ID ,UP.FIRST_NAME,
		  UP.LAST_NAME,UP.PROFILE_PHOTO,
		  UP.USER_NAME,
		  UP.JOB_TITLE,convert(char(13),
		  UP.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		  UP.CAR_IND_TYPE,SI.SIGNUP_EMAIL  FROM  [dbo].[USER_PROFILE] UP 
		  INNER JOIN SIGNUP_INFO SI ON UP.SIGNUP_ID = SI.ID
		  WHERE ((UPPER(UP.FIRST_NAME) LIKE '%' + @p_var_UserName + '%' ) OR
	     (UPPER(UP.LAST_NAME) LIKE '%' + @p_var_UserName + '%' ) ) AND UP.USER_ID<>@p_UserID
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SearchContact]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<SIDDHARAM>
-- Create date: <13-SEPT-2016>
-- Description:	<TO SEARCH CONTACT LIST >
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SearchContact]
	-- Add the parameters for the stored procedure here
	@p_var_UserName varchar(30),
	@p_SignUpID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare
	@p_var_USERID BIGINT,
	@p_searchCount BIGINT


	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT @p_var_USERID = USER_ID FROM USER_PROFILE WHERE SIGNUP_ID = @p_SignUpID
    print(@p_var_USERID);

	;WITH USERIDRECORD AS (

	SELECT SENTBY_USER_ID  AS USERID, 
	1 AS TYPE  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_var_UserID) 
		AND REQUEST_STATUS=1
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID  ,1 AS TYPE 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_var_UserID 
		AND REQUEST_STATUS=1
		UNION
		select USER_ID  AS USERID, 
		2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID=@p_var_UserID AND DELETE_FLAG=0
		UNION
		SELECT @p_var_UserID AS USERID,3 AS TYPE   --Self
	
	),

	POSTCOUNT AS(

	SELECT POST_ID,
	  ISNULL(TYPE,0) AS TYPE,
	CASE WHEN ISNULL(TYPE,0) = 1 THEN 
		CASE WHEN UPP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,3,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	 ISNULL(TYPE,0)= 2 THEN
		CASE WHEN UPP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1,4,5) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	ISNULL(TYPE,0)= 0 THEN
		CASE WHEN UPP.POST_VIEW_OPTION_POSTVIEW_OPTION_ID IN (1) THEN 1 ELSE 0 END 
	ELSE CASE WHEN 	 ISNULL(TYPE,0) = 3 THEN 1 END
	END	END END AS SHOWPOST
	FROM  USER_POSTS UPP
	LEFT JOIN USERIDRECORD URR
	ON URR.USERID=UPP.USER_ID 
	WHERE UPP.POST_CONTAINT LIKE '%'+@p_var_UserName+'%' 
	)

SELECT @p_searchCount=COUNT(*) FROM POSTCOUNT where SHOWPOST=1
    
    SELECT DISTINCT 1 AS TABLE1,UP.FIRST_NAME,
	UP.USER_NAME,
	UP.USER_ID,
	UP.SIGNUP_ID,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO
	FROM USER_PROFILE UP
	LEFT JOIN dbo.FRIENDS_REQUESTS FR ON (UP.USER_ID = FR.SENTBY_USER_ID)
	
	WHERE  ((UPPER(UP.FIRST_NAME) LIKE '%' + @p_var_UserName + '%' ) OR
	(UPPER(UP.LAST_NAME) LIKE '%' + @p_var_UserName + '%' ) ) AND USER_ID<>@p_var_USERID



	SElect @p_searchCount AS COUNT
    
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEARCHUSER_POST]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 17-OCT-16
-- Description:	To show search result User list
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SEARCHUSER_POST]
	-- Add the parameters for the stored procedure here
    @p_var_UserName varchar(30),
	@p_SignUpID BIGINT
  AS
  BEGIN
   Declare
	@p_var_USERID BIGINT,
	@p_searchCount BIGINT


	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT @p_var_USERID = USER_ID FROM USER_PROFILE WHERE SIGNUP_ID = @p_SignUpID
;WITH USERIDRECORD AS (

	SELECT SENTBY_USER_ID  AS USERID, 
	1 AS TYPE  --Friend
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_var_UserID) 
		AND REQUEST_STATUS=1
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID  ,1 AS TYPE 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_var_UserID 
		AND REQUEST_STATUS=1
		UNION
		select USER_ID  AS USERID, 
		2 AS TYPE  from [dbo].[USER_FOLLOWERS]  --Follower
		WHERE FOLLOWER_USER_ID=@p_var_UserID AND DELETE_FLAG=0
		UNION
		SELECT @p_var_UserID AS USERID,3 AS TYPE   --Self
	
	)
    SELECT DISTINCT TOP 5  1 AS TABLE1,UP.FIRST_NAME,
	UP.USER_NAME,
	UP.USER_ID,
	UP.SIGNUP_ID,
	UP.LAST_NAME,
	UP.PROFILE_PHOTO,
    UR.TYPE AS FRIEND_FOLLOWER
	FROM USER_PROFILE UP
	LEFT JOIN USERIDRECORD UR ON (UP.USER_ID = UR.USERID)
	
	WHERE  ((UPPER(UP.FIRST_NAME) LIKE '%' + @p_var_UserName + '%' ) OR
	(UPPER(UP.LAST_NAME) LIKE '%' + @p_var_UserName + '%' ) ) AND UP.USER_ID<>@p_var_USERID



	SElect @p_searchCount AS COUNT
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SEE_ALL]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SIDDHARAM
-- Create date: 13-OCT-16
-- Description:	To show see the all list
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SEE_ALL]
			@p_var_UserSignupId BIGINT,
			@p_start int,
			@p_end int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

	
	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @p_var_UserSignupId

    -- Insert statements for procedure here
	
		;WITH RECORD AS(
		SELECT SENTBY_USER_ID  AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_UserID) AND REQUEST_STATUS<>2
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_UserID AND REQUEST_STATUS<>2
		UNION
		SELECT USER_ID AS USERID 
		FROM  [dbo].[USER_FOLLOWERS] WHERE 
		FOLLOWER_USER_ID=@p_UserID AND DELETE_FLAG<>1
		UNION 
		SELECT REMOVE_USER_ID AS USERID 
		FROM  [dbo].[USER_SUGGESTION_REMOVE] WHERE 
		USER_ID=@p_UserID
		),
       SEEALL AS(
       SELECT DISTINCT  1 As TABLE0,SI.SIGNUP_EMAIL,
        UP.SIGNUP_ID ,UP.FIRST_NAME,
		  UP.LAST_NAME,UP.PROFILE_PHOTO,
		  UP.USER_NAME,
		  UP.JOB_TITLE,convert(char(13),
		  UP.DATE_OF_BIRTH, 107) as DATE_OF_BIRTH ,
		  UP.CAR_IND_TYPE,
		 ROW_NUMBER() OVER (ORDER BY UP.SIGNUP_ID ASC) AS ROW_NUM
        FROM  [dbo].[USER_PROFILE] UP 
       LEFT Join USER_FOLLOWERS UF ON UF.USER_ID=UP.USER_ID AND UF.DELETE_FLAG=0
	   LEFT JOIN RECORD R ON UP.USER_ID = R.USERID 
	   INNER JOIN SIGNUP_INFO SI ON UP.SIGNUP_ID = SI.ID
	WHERE R.USERID IS NULL AND UP.USER_ID <> @p_UserID )
	SELECT * FROM SEEALL WHERE ROW_NUM BETWEEN @p_start AND @p_end
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SIGNUPINFO]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Siddharam
-- Create date: 20-sept-2016
-- Description:	to get sign up info
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SIGNUPINFO]
	-- Add the parameters for the stored procedure here
	@p_var_Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SIGNUP_NAME,SIGNUP_EMAIL FROM SIGNUP_INFO WHERE ID =@p_var_Id
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_SuggestionList]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_SuggestionList] 
	-- Add the parameters for the stored procedure here
		@p_var_UserSignupId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

	
	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @p_var_UserSignupId

    -- Insert statements for procedure here
	
		;WITH RECORD AS(
		SELECT SENTBY_USER_ID  AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		(RECEIVEDBY_USER_ID=@p_UserID) AND REQUEST_STATUS<>2
		UNION
		SELECT RECEIVEDBY_USER_ID AS USERID 
		FROM [dbo].[FRIENDS_REQUESTS] WHERE 
		SENTBY_USER_ID=@p_UserID AND REQUEST_STATUS<>2
		UNION
		SELECT USER_ID AS USERID 
		FROM  [dbo].[USER_FOLLOWERS] WHERE 
		FOLLOWER_USER_ID=@p_UserID AND DELETE_FLAG<>1
		UNION 
		SELECT REMOVE_USER_ID AS USERID 
		FROM  [dbo].[USER_SUGGESTION_REMOVE] WHERE 
		USER_ID=@p_UserID
		)


			SELECT DISTINCT TOP 5 1 As Suggestion , 
		UP.*,isnull(UF.USER_ID,0) as Follow FROM  [dbo].[USER_PROFILE] UP LEFT Join 
		USER_FOLLOWERS UF ON UF.USER_ID=UP.USER_ID AND UF.DELETE_FLAG=0
		LEFT JOIN RECORD R ON UP.USER_ID = R.USERID 
		WHERE R.USERID IS NULL AND UP.USER_ID <> @p_UserID ORDER BY USER_ID 

END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_UserIdForResetLink]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_UserIdForResetLink]
	-- Add the parameters for the stored procedure here
	@p_var_LinkId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		BEGIN TRY

				IF EXISTS(SELECT USER_ID FROM [dbo].[FORGOT_PWD]  WHERE LINK_ID =@p_var_LinkId AND IS_LINK_ACTIVE=1)
				BEGIN

					SELECT USER_ID,1 AS STATUS FROM [dbo].[FORGOT_PWD]  WHERE LINK_ID =@p_var_LinkId AND IS_LINK_ACTIVE=1;

				END
				ELSE
				BEGIN

					SELECT 0 AS STATUS;

				END

		END TRY
		BEGIN CATCH
				
				SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
		
		END CATCH 
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UNFRIEND_USER]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UNFRIEND_USER]
	-- Add the parameters for the stored procedure here
	@p_signup_sender INT,
	@p_signup_receiver INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE
@p_sender_userid INT,
@p_receiver_userid INT,
@p_return INT


	SET NOCOUNT ON;

    -- Insert statements for procedure here

	    SELECT @p_sender_userid=USER_ID FROM 
	 USER_PROFILE WHERE
	 SIGNUP_ID = @p_signup_sender

     SELECT @p_receiver_userid=USER_ID
	 FROM USER_PROFILE WHERE SIGNUP_ID = @p_signup_receiver

	SELECT * FROM [dbo].[FRIENDS_REQUESTS]
	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_STATUS=2 WHERE 
	SENTBY_USER_ID=@p_sender_userid
	AND RECEIVEDBY_USER_ID=@p_receiver_userid


	SELECT * FROM [dbo].[FRIENDS_REQUESTS]
	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_STATUS=2 WHERE 
	RECEIVEDBY_USER_ID=@p_sender_userid
	AND SENTBY_USER_ID=@p_receiver_userid

END

GO
/****** Object:  StoredProcedure [dbo].[USP_Update_AddPostToPhoto]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Update_AddPostToPhoto]
	-- Add the parameters for the stored procedure here
	@p_PostID BIGINT,
	@p_typeid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if @p_typeid =1
begin
    -- Insert statements for procedure here
	UPDATE USER_POSTS SET POST_HAS_PHOTO = 1 WHERE POST_ID=@p_PostID
	END
else 
    UPDATE USER_POSTS SET POST_HAS_VIDEO = 2 WHERE POST_ID = @p_PostID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_ChangePassword]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_ChangePassword] 
	-- Add the parameters for the stored procedure here
	@p_var_Password VARCHAR(50),
	@p_var_UserID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
	 IF EXISTS( SELECT UP.USER_ID FROM USER_PROFILE UP LEFT JOIN
				[dbo].[FORGOT_PWD] FP ON UP.USER_ID=FP.USER_ID
				WHERE UP.USER_ID=@p_var_UserID AND IS_LINK_ACTIVE=1 )

			BEGIN

				UPDATE USER_PROFILE SET USER_PWD=@p_var_Password WHERE USER_ID=@p_var_UserID

				UPDATE [dbo].[FORGOT_PWD] SET IS_LINK_ACTIVE=0 WHERE USER_ID=@p_var_UserID AND IS_LINK_ACTIVE=1

				SELECT 1 AS STATUS
			END 
			ELSE

			BEGIN
				SELECT 0 AS STATUS		
			END 	
	END TRY
	BEGIN CATCH

			SELECT	ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;

	END CATCH
END



GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_COVER_PHOTO]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_COVER_PHOTO]
	-- Add the parameters for the stored procedure here
	@p_var_PostPhotoUrl varchar(100),
	@p_var_PostID BIGINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	


	UPDATE USER_PROFILE 
	SET USER_COVER_PHOTO = @p_var_PostPhotoUrl 
	WHERE SIGNUP_ID = @p_var_PostID
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_Request_Seen_Status]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_Request_Seen_Status]
	-- Add the parameters for the stored procedure here
	@p_var_UserSignupID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE 
	@p_UserID BIGINT

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @p_UserID = USER_ID FROM 
	USER_PROFILE WHERE 
	SIGNUP_ID = @p_var_UserSignupId


	UPDATE [dbo].[FRIENDS_REQUESTS] SET REQUEST_SEEN=1 WHERE 
	RECEIVEDBY_USER_ID=@p_UserID

END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UpdateContributorPost]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_UpdateContributorPost]
	-- Add the parameters for the stored procedure here
	@p_var_PostId BIGINT,
	@p_var_PostDate DATE,
	
	@p_var_VideoUrl varchar(200),
	--@p_var_PostHeadLine1 varchar(500),
	@p_var_PostHeadLine2 varchar(1000),
	@p_var_PostWebLink varchar(300),
	@p_var_PostViewOptionId int,
	@p_var_PostTag varchar(100),
	@p_var_PostExpertise varchar(100),
	@p_var_PostMood varchar(100),
	@p_var_Hasphoto bit,
	@p_var_Hasvideo bit,
	@p_var_Ispublish bit,
	@p_var_PostContaint varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @Post_ID BIGINT,
		 @USERID BIGINT
		


	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 BEGIN TRY



				SELECT @Post_ID=@p_var_PostId
				SELECT @USERID=USER_ID 
				FROM  [DBO].[USER_POSTS]
				WHERE POST_ID=@p_var_PostId
			IF @p_var_Ispublish=0
			BEGIN
				UPDATE USER_POSTS SET 
				POST_DATE=@p_var_PostDate,
				POST_VIDEO_URL=@p_var_VideoUrl,
				--POST_HEADLINE_1=@p_var_PostHeadLine1,
				POST_HEADLINE_2=@p_var_PostHeadLine2,
				POST_WEBSITE_LINK=@p_var_PostWebLink,
				POST_VIEW_OPTION_POSTVIEW_OPTION_ID=@p_var_PostViewOptionId,
				POST_HAS_PHOTO=@p_var_Hasphoto,
				POST_HAS_VIDEO=@p_var_Hasvideo,
				POST_CONTAINT=@p_var_PostContaint
				WHERE POST_ID=@p_var_PostId
			END
			ELSE
			BEGIN
				UPDATE USER_POSTS SET 
				POST_DATE=@p_var_PostDate,
				POST_VIDEO_URL=@p_var_VideoUrl,
				--POST_HEADLINE_1=@p_var_PostHeadLine1,
				POST_HEADLINE_2=@p_var_PostHeadLine2,
				POST_WEBSITE_LINK=@p_var_PostWebLink,
				POST_VIEW_OPTION_POSTVIEW_OPTION_ID=@p_var_PostViewOptionId,
				POST_HAS_PHOTO=@p_var_Hasphoto,
				POST_HAS_VIDEO=@p_var_Hasvideo,
				POST_IS_PUBLISH=@p_var_Ispublish,
				POST_CONTAINT=@p_var_PostContaint
				WHERE POST_ID=@p_var_PostId
			END
			---------------------------------------------------------------------------
				DELETE FROM USER_POSTS_TAGS WHERE POST_ID=@p_var_PostId
				IF @p_var_PostTag <> ''
				BEGIN

					INSERT INTO TAGS_MASTER(TAG_KEYWORD)  SELECT String FROM splitFunction (@p_var_PostTag,',' ) 
					WHERE NOT EXISTS(SELECT TAG_KEYWORD FROM TAGS_MASTER WHERE TAG_KEYWORD=String);

					INSERT INTO USER_POSTS_TAGS(USER_ID,
												POST_ID,
												TAGS_ID)  
					SELECT @USERID,@Post_ID,TM.ID FROM TAGS_MASTER TM 
					WHERE  EXISTS(SELECT String FROM splitFunction (@p_var_PostTag,',' ) WHERE String=TM.TAG_KEYWORD)
				END 

			-------------------------------------------------------------------------------------	
				DELETE FROM USER_POST_EXPERTISE WHERE USER_POSTS_POST_ID=@p_var_PostId
				IF @p_var_PostExpertise <> ''
				BEGIN

					
					INSERT INTO USER_POST_EXPERTISE(USER_POSTS_USER_ID,
													USER_POSTS_POST_ID,
													EXPERTISE_AREA_ID) 

					SELECT @USERID,@Post_ID,String FROM splitFunction (@p_var_PostExpertise,',' )  

				END 

			-----------------------------------------------------------------------------------
			DELETE FROM USER_POST_MOODS WHERE USER_POSTS_POST_ID=@Post_ID
				IF @p_var_PostMood <> ''
				BEGIN

					
					INSERT INTO USER_POST_MOODS(USER_POSTS_USER_ID,
													USER_POSTS_POST_ID,
													MOODS_ID) 

					SELECT @USERID,@Post_ID,String FROM splitFunction (@p_var_PostMood,',' )  

				END 

				SELECT @Post_ID AS POST_ID
		END TRY
			BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH 

END



GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UpdatePostPhoto]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_UpdatePostPhoto]
	-- Add the parameters for the stored procedure here
	@p_var_PostPhotoUrl varchar(100),
	@p_var_PostID BIGINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	


	UPDATE USER_POSTS 
	SET POST_PHOTO_URL=@p_var_PostPhotoUrl 
	WHERE POST_ID=@p_var_PostID
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UserProfile]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Avinash Chandanshive
-- Create date: 7/12/2016,
-- Description:	To update User Profile,
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_UserProfile]
	-- Add the parameters for the stored procedure here
	@p_var_SignUpID BIGINT,
	@p_var_RoleId INT,
	@p_var_UserName VARCHAR(15),
	@p_var_UserPwd VARCHAR(50),
	@p_var_ProfilePhoto VARCHAR(300),
	@p_var_FirstName VARCHAR(30),
	@p_var_LastName VARCHAR(30),
	@p_var_UserTitle VARCHAR(30),
	@p_var_DateBirth DATE,
	@p_var_CarIndType VARCHAR(100),
	@p_var_JobTitle VARCHAR(50),
	@p_var_CompanyName VARCHAR(100),
	@p_var_UserBio VARCHAR(1000),
	@p_var_UserExpt VARCHAR(75),
	@p_var_UserTag VARCHAR(1000),
	@p_var_UserEmail VARCHAR(50)

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @User_ID INT,
	 @Count INT
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  BEGIN TRY

			SELECT @Count=COUNT(*) FROM [dbo].[SIGNUP_INFO] WHERE 
			SIGNUP_EMAIL= @p_var_UserEmail AND ID <> @p_var_SignUpID

			IF @Count <=0
			BEGIN
						UPDATE USER_PROFILE SET ROLE_ID	=@p_var_RoleId,
												USER_NAME=@p_var_UserName,
												USER_PWD=@p_var_UserPwd,
									
												FIRST_NAME	=@p_var_FirstName,
												LAST_NAME=@p_var_LastName,
												USER_TITLE	=@p_var_UserTitle,
												DATE_OF_BIRTH	=@p_var_DateBirth,
												CAR_IND_TYPE=@p_var_CarIndType,
												JOB_TITLE=@p_var_JobTitle,
												COMPANY_NAME=@p_var_CompanyName,
												USER_BIO	=@p_var_UserBio,
												MODIFIED_DATE	=GETDATE()
						WHERE SIGNUP_ID=@p_var_SignUpID

						UPDATE [dbo].[SIGNUP_INFO] SET SIGNUP_EMAIL=@p_var_UserEmail
						WHERE ID = @p_var_SignUpID

						SELECT @User_ID=USER_ID FROM USER_PROFILE WHERE SIGNUP_ID=@p_var_SignUpID

						--Insert Tag--
							IF @p_var_UserTag <> ''
							BEGIN

								INSERT INTO TAGS_MASTER(TAG_KEYWORD)  SELECT String FROM splitFunction (@p_var_UserTag,',' ) 
								WHERE NOT EXISTS(SELECT TAG_KEYWORD FROM TAGS_MASTER WHERE TAG_KEYWORD=String);

								DELETE FROM USER_TAGS WHERE USER_ID=@User_ID

								INSERT INTO USER_TAGS(USER_ID,TAGS_ID)  SELECT @User_ID,TM.ID FROM TAGS_MASTER TM 
								WHERE  EXISTS(SELECT String FROM splitFunction (@p_var_UserTag,',' ) where String=TM.TAG_KEYWORD)
							END 


						--Insert Expertise--
							IF @p_var_UserExpt <> ''
							BEGIN

								DELETE FROM USER_EXPERTISE WHERE USER_ID=@User_ID
								INSERT INTO USER_EXPERTISE(USER_ID,EXPERTISE_AREA_ID) 
								SELECT @User_ID,String FROM splitFunction (@p_var_UserExpt,',' )  

							END 
							SELECT @User_ID AS ID,1 AS STATUS
			END
			ELSE
							BEGIN
							SELECT 0 AS ID,0 AS STATUS
							END
	  END TRY
			BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
			END CATCH 
END




GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_UserProfilePhoto]    Script Date: 08-Nov-16 5:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_UserProfilePhoto] 
	-- Add the parameters for the stored procedure here
	@p_var_Signup_ID BIGINT,
	@p_var_Profile varchar(300)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

     BEGIN TRY
				UPDATE USER_PROFILE SET PROFILE_PHOTO=@p_var_Profile WHERE SIGNUP_ID = @p_var_Signup_ID
				SELECT 1 As Status

	END TRY
	BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH  
END

GO
