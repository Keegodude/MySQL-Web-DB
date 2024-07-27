use music;
DELIMITER //

CREATE PROCEDURE GenerateReport(IN genre VARCHAR(255), IN decade INT, IN artistmonthly INT, IN artist_country VARCHAR(255), IN sortvariable VARCHAR(255))
BEGIN
    SELECT Songs.*, Artists.*, PlaylistID
    FROM Playlist_songs
    INNER JOIN Songs ON Playlist_songs.songID = Songs.songID
    INNER JOIN Artists ON Songs.song_artistID = Artists.ArtistID
    WHERE (genre IS NULL OR Songs.genre = genre) AND (decade IS NULL OR Songs.decade = decade) AND
          (artistmonthly IS NULL OR Artists.monthly_listeners <=artistmonthly) AND (artist_country IS NULL OR Artists.country = artist_country)
    order by sortvariable desc;
END;

DELIMITER ;
