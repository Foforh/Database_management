USE MiniInsta;

#select * from User;

#select * from User where ID = 191;

#select * from User where Username = 'cbaccup3b';

-- --------------------------------------------------------
-- Front page query (posts by the people I follow, number of
-- likes for each post)
-- --------------------------------------------------------
SET @UserId = 64;

SELECT DISTINCT User.ID, User.Username, Post.CreationTime, PostMedia.MediaTypeId, PostMedia.MediaFileUrl, Count(Liking.UserID) as TotalLikes
FROM User , Post, PostMedia, Liking
WHERE Post.UserId IN (SELECT FollowerUserId from Following where FolloweeUserId = @UserId)
AND User.ID = Post.UserId and PostMedia.PostId = Post.ID and Liking.PostId = Post.ID
GROUP BY Post.ID, User.Username, Post.CreationTime, PostMedia.MediaTypeId, PostMedia.MediaFileUrl, Liking.UserID
;
 

 
-- --------------------------------------------------------
-- Profile page
-- Main portion: header with username, profile image, # of posts,
-- # of followers, # of followings, bio
-- Posts by this user in cronologically descending order, 
-- including one media file and # of total media files
-- --------------------------------------------------------
SET @Username = 'mrewan1r';
SET @UserId = 64;

select a.Username, a.ID, a.Website , a.Bio, a.ProfileImageUrl, 
Count(distinct b.ID), Count(distinct c.FollowerUserId) - 1, Count(distinct c.FolloweeUserId) - 1
from User as a, Post as b, Following as c
where a.Username = @Username and b.UserId = a.ID and (c.FollowerUserId = a.ID or c.FolloweeUserId = a.ID); 

-- we substract "1" from followers and followees because we have to skip the User itself

select a.ID, a.LocationName, b.Name as MediaType, c.MediaFileUrl
from Post as a, MediaType as b, PostMedia as c, User as d
where d.ID = a.UserId and c.MediaTypeId = b.ID and c.PostId = a.ID and d.Username = @Username
group by a.ID, a.LocationName, b.Name;

-- --------------------------------------------------------
-- Post details
-- Main query: header info (username, profile picture, # of likes)
-- Media files
-- Comments
-- --------------------------------------------------------
SET @PostID = 74;

select a.ID, b.Username, b.ProfileImageUrl, a.LocationName, a.Location, Count(d.UserId) as NumberOfLikes
from Post as a, User as b, Liking as d
where a.ID = @PostId and b.ID = a.UserId and d.UserId = b.ID; 

select a.ID, a.MediaTypeID, a.MediaFileUrl
from PostMedia as a, Post as b
where b.ID = a.PostId and b.ID = @PostId;

select a.ID, a.Comment, a.CreationTime
from Comment as a, Post as b
where b.ID = a.PostId and b.ID = @PostId
order by a.CreationTime;



-- --------------------------------------------------------
-- Analytical numbers in single data set (total number of users, 
-- total number of posts, Average and max posts per user, 
-- avg and max comments per post, avg ja max likes per post
-- --------------------------------------------------------

select  Count(distinct a.ID) as TotalNumberOfUsers, Count(distinct b.ID) as TotalNumberOfPosts,
f.AverageNumberOfPosts, f.AverageNumberOfComments, f.AverageNumberOfLikes, 
Max(f.AverageNumberOfPosts), Max(f.AverageNumberOfComments), Max(f.AverageNumberOfLikes)
from 
(select avg(a.AverageNumberOfPosts) as AverageNumberOfPosts, avg(b.AverageNumberOfComments) as AverageNumberOfComments,
avg(c.AverageNumberOfLikes) as AverageNumberOfLikes
from
(select Count(a.ID) as AverageNumberOfPosts from Post as a
group by a.UserID) a,
(select Count(a.ID) as AverageNumberOfComments
from Comment as a group by a.PostID) b,
(select Count(a.PostID) as AverageNumberOfLikes
from Liking as a group by a.PostID) c) f, User as a, Post as b;

----------------------------------------------------------
-- TOP 10 Users with most posts
----------------------------------------------------------
SELECT Count(Post.ID) AS PostNumber, Post.UserID, User.Username
FROM User,Post
WHERE Post.UserID = User.ID
GROUP BY Post.UserID
ORDER BY PostNumber DESC
LIMIT 10;


----------------------------------------------------------
-- User registration count per day
----------------------------------------------------------
SELECT ID, Username, CreationTime FROM User;
----------------------------------------------------------
-- User division by gender
----------------------------------------------------------
SELECT  User.Username, User.ID, Gender.Name
FROM User, Gender
WHERE User.GenderID = Gender.ID
ORDER BY User.ID;
