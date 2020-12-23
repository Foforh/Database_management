USE MiniBooking;
select * from User;
select * from User where UserID = 191;

-- --------------------------------------------------------
-- Feedbacks by the given user
-- --------------------------------------------------------
SET @UserId = 191;
select * from FEEDBACK where UserId=191;
-- --------------------------------------------------------
-- Amounts of booking and review done by a specific customers his detail and the review.
-- --------------------------------------------------------
SET @UserID = 65;

SELECT DISTINCT USER.UserID, USER.Username, USER.Name, USER.EmailID, BOOKING.CustomerID , REVIEW.ReviewComments, REVIEW.CustomerID ,  COUNT(REVIEW.ReviewID) AS TotalReview, COUNT(BOOKING.BookingID) as TotalBooking
FROM USER, BOOKING , REVIEW
WHERE BOOKING.CustomerID IN (SELECT CustomerID FROM CUSTOMER WHERE CustomerID = @UserId)
and BOOKING.CustomerID = USER.UserID AND REVIEW.CustomerID = USER.UserID
GROUP BY USER.UserID, User.Username, USER.Name, USER.EmailID, BOOKING.CustomerID ,REVIEW.CustomerID , REVIEW.ReviewComments, REVIEW.ReviewID ,BOOKING.BookingID
;

-- --------------------------------------------------------
-- Location for the house owned by a specific host and his contact
-- --------------------------------------------------------
SET @HostID = 382;

SELECT DISTINCT HOUSE.HostID, HOUSE.HouseID , HOUSE.LocationID , HOUSE.StreetName , HOUSE.AptNumber , LOCATION.LocationID , LOCATION.Country , LOCATION.City , USER.UserID , USER.UserName , USER.EmailID
FROM HOST, HOUSE , LOCATION , USER
WHERE HOUSE.HostID  IN (SELECT HostID FROM HOST WHERE HostID = @HostID) 
 AND HOUSE.LocationID = LOCATION.LocationID AND USER.UserID = HOUSE.HostID
GROUP BY User.UserName,USER.EmailID, HOUSE.HostID, HOUSE.HouseID , HOUSE.StreetName, House.AptNumber ,LOCATION.Country , LOCATION.City;
-- --------------------------------------------------------

-- --------------------------------------------------------
