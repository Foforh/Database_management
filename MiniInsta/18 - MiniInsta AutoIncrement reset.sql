USE MiniInsta;

drop PROCEDURE if exists ResetAutoincrement;
DELIMITER //
CREATE PROCEDURE ResetAutoincrement (TableName varchar(50))
BEGIN
    set @qry1 = concat('SELECT MAX(`ID`) + 1 as autoincrement FROM `', TableName, '` INTO @ai'); 
    PREPARE stmt1 FROM @qry1;
    EXECUTE stmt1;

    IF @ai IS NOT NULL THEN
        set @qry2 = concat('ALTER TABLE `', TableName, '` AUTO_INCREMENT = ', @ai);
        PREPARE stmt2 FROM @qry2;
        EXECUTE stmt2;
        DEALLOCATE PREPARE stmt2;
    END IF;

    DEALLOCATE PREPARE stmt1;
END
//
DELIMITER ;

-- SELECT Max(ID) FROM User;
CALL ResetAutoincrement ('User');

-- SELECT Max(ID) FROM Post;
CALL ResetAutoincrement ('Post');

-- SELECT Max(ID) FROM Comment;
CALL ResetAutoincrement ('Comment');

-- SELECT Max(ID) FROM PostMedia;
CALL ResetAutoincrement ('PostMedia');

SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'MiniInsta' AND TABLE_NAME   = 'User';
SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'MiniInsta' AND TABLE_NAME   = 'Post';
SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'MiniInsta' AND TABLE_NAME   = 'Comment';
SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'MiniInsta' AND TABLE_NAME   = 'PostMedia';

