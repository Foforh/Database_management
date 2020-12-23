USE MiniInsta;
-- select * from User;
-- select * from User where ID = 191;
-- select * from User where Username = 'cbaccup3b';
-- --------------------------------------------------------
-- Front page query (posts by the people I follow, number of
-- likes for each post)
-- --------------------------------------------------------
SET @UserId = 120;

SELECT DISTINCT User.ID, User.Username, Post.CreationTime, PostMedia.MediaTypeId, PostMedia.MediaFileUrl, COUNT(Liking.UserID) as TotalLikes
FROM User , Post, PostMedia, Liking
WHERE Post.UserId IN (SELECT FollowerUserId FROM Following WHERE FolloweeUserId = @UserId)
AND User.ID = Post.UserId AND PostMedia.PostId = Post.ID AND Liking.PostId = Post.ID
GROUP BY Post.ID, User.Username, Post.CreationTime, PostMedia.MediaTypeId, PostMedia.MediaFileUrl, Liking.UserID
;
-- --------------------------------------------------------
-- Profile page
-- Main portion: header with username, profile image, # of posts,
-- # of followers, # of followings, bio
-- Posts by this user in cronologically descending order, 
-- including one media file and # of total media files
-- --------------------------------------------------------
SET @Username = 'cbaccup3b';
SELECT User.Username, User.ID, User.Website , User.Bio, User.ProfileImageUrl, 
Count(DISTINCT Post.ID) AS NumberofPosts, Count(DISTINCT Following.FollowerUserId) AS NumberofFollowingUser, Count(DISTINCT Following.FolloweeUserId) AS NumberofFollower
FROM User, Post, Following
WHERE User.Username = @Username and Post.UserId = User.ID and (Following.FollowerUserId = User.ID or Following.FolloweeUserId = User.ID)
GROUP BY  User.Username, User.ID, User.Website , User.Bio, User.ProfileImageUrl; 
SELECT Post.ID, Post.LocationName, MediaType.Name as MediaType,(SELECT PostMedia.MediaFileUrl FROM PostMedia, Post WHERE Post.ID = PostMedia.PostID limit 1)
FROM Post, MediaType, PostMedia, User
WHERE User.ID = Post.UserId and PostMedia.MediaTypeId = MediaType.ID and PostMedia.PostId = Post.ID and User.Username = @Username
GROUP BY  Post.ID, Post.LocationName, MediaType.Name
ORDER BY Post.CreationTime DESC;

-- --------------------------------------------------------
-- Post details
-- Main query: header info (username, profile picture, # of likes)
-- Media files
-- Comments
-- --------------------------------------------------------
SET @PostID = 74;
SELECT * FROM (SELECT DISTINCT Post.ID, User.Username, User.ProfileImageUrl, Post.LocationName, Post.Location, IF(Liking.PostID = Post.ID, COUNT(Liking.PostID), 1) AS LikesNumber
FROM Post, User, Liking
WHERE User.ID = Post.UserID AND Post.ID = @PostId
GROUP BY Post.ID, User.Username, User.ProfileImageUrl, Post.LocationName, Post.Location, Liking.PostID) AS N
ORDER BY  N.LikesNumber DESC
LIMIT 1;
SELECT PostMedia.ID, PostMedia.MediaTypeID, PostMedia.MediaFileUrl
FROM PostMedia, Post
WHERE Post.ID = PostMedia.PostId and Post.ID = @PostId
GROUP BY PostMedia.ID, PostMedia.MediaTypeID, PostMedia.MediaFileUrl;

SELECT Comment.ID, Comment.Comment, Comment.CreationTime
FROM Comment, Post
WHERE Post.ID = Comment.PostId AND Post.ID = @PostId
GROUP BY Comment.ID, Comment.Comment, Comment.CreationTime
ORDER BY Comment.CreationTime;


-- --------------------------------------------------------
-- Analytical numbers in single data set (total number of users, 
-- total number of posts, Average and max posts per user, 
-- avg and max comments per post, avg ja max likes per post
-- --------------------------------------------------------
----------------------------------------------------------
-- TOP 10 Users with most posts
----------------------------------------------------------
----------------------------------------------------------
-- User registration count per day
----------------------------------------------------------
----------------------------------------------------------
-- User division by gender
----------------------------------------------------------

