from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
import secrets

app = Flask(__name__)
#Session handling
secret_key = secrets.token_hex(16)
app.secret_key = secret_key

# sql connector: specify your mysql env info here
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'music'
}


def get_db_connection():
    return mysql.connector.connect(**db_config)


def execute_query(query, params=None, fetchall=True):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(query, params)
    result = cursor.fetchall() if fetchall else None
    connection.commit()
    connection.close()
    return result

# ENV PREP
#execute_query("SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED", )
#execute_query("CREATE INDEX idx_playlistID ON playlists(PlaylistID)", )
#execute_query("CREATE INDEX idx_songID ON songs(songID)", )
#execute_query("CREATE INDEX idx_userID ON users(UserID)", )


@app.route('/')
def start():
    return redirect(url_for('signin'))





@app.route('/playlists')
def returnto_playlist():
    return redirect(f'/playlists/{session.get("user_id")}')

# SESSION EXPIRATION HANDLING
@app.route('/playlists/None')
def returnto_signin():
    return render_template('session_expired.html')

@app.route('/show_songs/None')
def returnto_signin_songs():
    return render_template('session_expired.html')

# USER'S PLAYLIST HOME PAGE
@app.route('/playlists/<int:user_id>')
def playlists(user_id):
    playlists = execute_query("SELECT * FROM Playlists WHERE owner_UserID = %s", (user_id,))
    return render_template('playlists.html', playlists=playlists)

# ACCOUNT FUNCTIONALITY
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        execute_query("INSERT INTO Users (password, username, email) VALUES (%s, %s,%s)",
                      (password, username, email))
        return redirect(url_for('signin'))
    else:
        return render_template('register.html')

@app.route('/signin', methods=['GET', 'POST'])
def signin():
    if request.method == 'POST':
        username = request.form['username']
        user = execute_query("SELECT UserID FROM Users where username = %s", (username,))
        if user:
            session['user_id'] = user[0][0]
            return redirect(f"/playlists/{user[0][0]}")
        else:
            return "User not found."
    else:
        return render_template('signin.html')

@app.route('/delete_account', methods=['GET', 'POST'])
def delete_account():
    execute_query("DELETE FROM Users WHERE UserID=%s", (session.get("user_id"),))
    return redirect(url_for('signin'))


# GENERAL PLAYLIST EDITING
@app.route('/rename_playlist/<int:playlist_id>', methods=['GET', 'POST'])
def rename_playlist(playlist_id):
    if request.method == 'POST':
        new_name = request.form['name']
        execute_query("UPDATE Playlists SET playlist_name = %s WHERE PlaylistID = %s", (new_name, playlist_id))
        return redirect(f'/playlists/{session.get("user_id")}')
    else:
        playlist_name = execute_query("SELECT playlist_name FROM Playlists WHERE PlaylistID = %s", (playlist_id,))
        return render_template('rename_playlist.html', playlist_id=playlist_id, playlist_name=playlist_name)


@app.route('/add_playlist', methods=['GET', 'POST'])
def add_playlist():
    if request.method == 'POST':
        playlist_name = request.form['playlist_name']

        execute_query("INSERT INTO playlists (owner_UserID,playlist_name) VALUES (%s, %s)",
                      (session.get('user_id'), playlist_name))

        return redirect(f'/playlists/{session.get("user_id")}')
    else:
        return render_template('add_meeting.html')


@app.route('/delete_playlist/<int:playlist_id>', methods=['POST'])
def delete_playlist(playlist_id):
    if request.method == 'POST':

        execute_query("DELETE FROM playlists WHERE PlaylistID=%s", (playlist_id,))
        return redirect(f'/playlists/{session.get("user_id")}')
    else:
        return render_template('delete_playlist.html')


# PLAYLIST SONG FUNCTIONALITY
@app.route('/show_songs/<int:playlist_id>')
def show_songs(playlist_id):
    session['playlist_id'] = playlist_id
    playlist_songs = execute_query(
        "SELECT  Songs.songID, Songs.name AS song_name, Artists.name AS artist_name FROM Playlist_songs INNER JOIN Songs ON Playlist_songs.songID = Songs.songID INNER JOIN Artists ON Songs.song_artistID = Artists.ArtistID WHERE Playlist_songs.PlaylistID = %s",
        (playlist_id,))
    available_songs = execute_query(
        "SELECT Songs.songID, Songs.name AS song_name, Artists.name AS artist_name FROM Songs LEFT JOIN Playlist_songs ON Songs.songID = Playlist_songs.songID AND Playlist_songs.PlaylistID = %s INNER JOIN Artists ON Songs.song_artistID = Artists.ArtistID WHERE Playlist_songs.songID IS NULL GROUP BY Artists.name, Songs.songID",
        (playlist_id,))
    playlist_songs_genres = execute_query("SELECT distinct Songs.genre as song_genre from Songs JOIN Playlist_songs on Songs.songID = Playlist_songs.songID AND Playlist_songs.PlaylistID = %s order by song_genre", (playlist_id,))
    playlist_songs_decades = execute_query("SELECT DISTINCT Songs.decade as song_decade FROM Songs JOIN Playlist_songs on Songs.songID = Playlist_songs.songID AND Playlist_songs.PlaylistID = %s order by song_decade desc", (playlist_id,))
    playlist_songs_artistmonthly = execute_query("SELECT DISTINCT Artists.monthly_listeners as artistmonthly from Songs JOIN Playlist_songs on Songs.songID = Playlist_songs.songID JOIN Artists on Songs.song_artistID = Artists.ArtistID where Playlist_songs.PlaylistID = %s", (playlist_id,))
    playlist_songs_artist_country = execute_query("SELECT DISTINCT Artists.country as artist_country from Songs JOIN Playlist_songs on Songs.songID = Playlist_songs.songID JOIN Artists on Songs.song_artistID = Artists.ArtistID where Playlist_songs.PlaylistID = %s order by artist_country", (playlist_id,))

    playlist_songs_info = execute_query(
        "SELECT distinct Songs.genre as song_genre, Songs.decade as song_decade, Artists.monthly_listeners as artistmonthly, Artists.country as artist_country from Songs JOIN Playlist_songs on Songs.songID = Playlist_songs.songID JOIN Artists on Songs.song_artistID = Artists.ArtistID where Playlist_songs.PlaylistID = %s",
        (playlist_id,))
    return render_template('playlist_songs.html', available_songs=available_songs, playlist_songs=playlist_songs,
                           playlist_songs_genres=playlist_songs_genres, playlist_songs_decades=playlist_songs_decades, playlist_songs_artistmonthly=playlist_songs_artistmonthly, playlist_songs_artist_country=playlist_songs_artist_country)


@app.route('/add_song_to_playlist', methods=['POST'])
def add_song_to_playlist():
    playlist_id = session.get("playlist_id")
    selected_song_id = request.form['song_id']

    execute_query("INSERT INTO Playlist_songs (PlaylistID, songID) VALUES (%s, %s)", (playlist_id, selected_song_id), )

    return redirect(f'/show_songs/{session.get("playlist_id")}')


@app.route('/delete_song_from_pl/<int:song_id>')
def delete_song(song_id):
    playlist_id = session.get("playlist_id")

    execute_query("DELETE FROM Playlist_songs where Playlistid = %s and songID = %s", (playlist_id, song_id), )

    return redirect(f'/show_songs/{session.get("playlist_id")}')

# FILTERED REPORT CREATION
@app.route('/generate_report', methods=['GET', 'POST'])
def generate_report():
    if request.method == 'POST':
        genre = request.form['genre']
        decade = request.form['decade']
        artistmonthly = request.form['artistmonthly']
        artist_country = request.form['artist_country']
        sortvariable = request.form['sortvariable']

        if not genre:
            genre = None
        if not decade:
            decade = None
        if not artistmonthly:
            artistmonthly = None
        if not artist_country:
            artist_country = None
        if not sortvariable:
            sortvariable = None

        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        cursor.callproc('GenerateReport', [genre, decade, artistmonthly, artist_country, sortvariable])

        report_data = []
        for result in cursor.stored_results():
            rows = result.fetchall()
            for row in rows:
                report_data.append(row)

        cursor.close()
        connection.close()
        if report_data:
            return render_template('report.html', report_data=report_data)
        else:
            return redirect(f'/show_songs/{session.get("playlist_id")}')



if __name__ == '__main__':
    app.run(debug=True)
