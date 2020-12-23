-- Analytical Queries of  Assignment - 4 
-- --------------------------------------------------------
USE MiniInsta;


Select (select Count(ID) from User) as 'TotalNumberOfUsers',
(select Count(ID) from Post) as 'TotalNumberOfPosts',
(Select AVG(Count) from (select Count(ID) as 'Count', UserID 
From Post 
Group by UserID) Count) as 'AvgNumberOfPostsPerUser',
(Select MAX(Count) from (select Count(ID) as 'Count', UserID 
From Post 
Group by UserID) Count) as 'MaxNumberOfPostsPerUser',
(Select AVG(Count) from (select Count(PostID) as 'Count', UserID 
From Liking 
Group by UserID) LikeCount) as 'AvgNumberOfLikesPerPost',
(Select MAX(Count) from (select Count(PostID) as 'Count', UserID 
From Liking 
Group by UserID) Count) as 'MaxNumberOfLikesPerPost';

-- TOP 10 Users with most posts

Select Count(Post.ID) as NumberOfPosts, Post.UserID, User.Username
From User , Post
Where Post.UserID = User.ID
Group by User.Username ,Post.UserID
Order by NumberOfPosts desc
Limit 10;

-- User registration count per day
Select Count(ID) as 'NumberOfRegistrations', DATE_FORMAT(CreationTime, "%d-%c-%Y") as 'Date' 
From User 
Group by CreationTime;


-- User division by gender
Select Count(User.ID) as 'NumberOfUsers' , Gender.Name 
From User 
Join Gender on User.GenderID = Gender.ID 
GROUP BY Gender.Name;  

