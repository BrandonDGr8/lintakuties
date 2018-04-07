package scraper;

import twitter4j.HashtagEntity;
import twitter4j.MediaEntity;
import twitter4j.Paging;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.URLEntity;
import twitter4j.User;
import twitter4j.UserMentionEntity;
import twitter4j.conf.ConfigurationBuilder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.time.DayOfWeek;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;

public class TwitterScraper {
	
	ArrayList<String> noiseWords;
	Connection connection;
	String user;
	
	public TwitterScraper(String user) {
		this.user = user;
	}
	
	public int scrape() throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
		
		loadStuff();
		return twitter();
	}
	
	public void loadStuff() {
		String[] noise = {"about", "after", "all", "also", "an", "and", "another", "any", "are", "as", "at", "be", 
				"because", "been", "before", "being", "between", "both", "but", "by", "came", "can", "come", "could", 
				"did", "do", "does", "each", "else", "for", "from", "get", "got", "has", "had", "he", "have", "her", 
				"here", "him", "himself", "his", "how", "if", "in", "into", "is", "it", "its", "just","like", "make", 
				"many", "me", "might", "more", "most", "much", "must", "my", "never", "now", "of", "on", "only", "or", 
				"other", "our", "out", "over", "re", "said", "same", "see", "she", "should", "since", "so", "some", 
				"still", "such", "take", "than", "that", "the", "their", "them", "then", "there", "these", "they", "this", 
				"those", "through", "to", "too", "under", "up", "use", "very", "want", "was", "way", "we", "well", "were", 
				"what", "when", "where", "which", "while", "who", "will", "with", "would", "you", "your", "a", "b", "c", "d", 
				"e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
		noiseWords = new ArrayList<String>(Arrays.asList(noise));
	}
	
	public int twitter() {
		ConfigurationBuilder cb = new ConfigurationBuilder();
		cb.setDebugEnabled(true)
		  .setOAuthConsumerKey("VSHE3JtKxoT1BtzCoWlWYh10Z")
		  .setOAuthConsumerSecret("UPZpTiMvOvhFtxUCl1bgXo3zqOBnYSo22YshtkfRhEZXae8BXO")
		  .setOAuthAccessToken("966845759801954305-XplJ9srbPe0ZKNGzVHktWt6NQwPeNix")
		  .setOAuthAccessTokenSecret("jY4GV0SAF1dfp1hZ5LuKrGv9i9gKpoF0dhMklPJFDQ6nn");
		
		Twitter twitter = new TwitterFactory(cb.build()).getInstance();
		
		
		try {
			User u = twitter.showUser(user);
			if (!u.isProtected()) {
				userInfo(u);
				List<Status> statuses = twitter.getUserTimeline(user, new Paging(1, 20));
				statuses.addAll(twitter.getUserTimeline(user, new Paging(2, 20)));
				statuses.addAll(twitter.getUserTimeline(user, new Paging(3, 20)));
				
				for (Status status : statuses) {
					statusInfo(status);
					scrapeTweet(status);
				}
				return 0;
			} else {
				return 1;
			}
		} catch (TwitterException e) {
			return 1;
		}
	}
	
	public void userInfo(User user) {
		try {
			int postCount = user.getStatusesCount();
			int followerCount = user.getFollowersCount();
			String username = user.getScreenName();
			String name = user.getName();
			
			PreparedStatement ps = connection.prepareStatement("INSERT INTO Account VALUES (?, ?, ?, ?)");
			ps.setString(1, username);
			ps.setString(2, name);
			ps.setInt(3, followerCount);
			ps.setInt(4, postCount);
			try {
				ps.executeUpdate();
			} catch (MySQLIntegrityConstraintViolationException e) {
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	public void statusInfo(Status status) {
		try {
			String id = Long.toString(status.getId());
			int favoriteCount = status.getFavoriteCount();
			int retweetCount = status.getRetweetCount();
			String text = status.getText();
			
			Date statusDate = status.getCreatedAt();
			
			Time time = new Time(statusDate.getTime());
			java.sql.Date date = new java.sql.Date(statusDate.getTime());
			DayOfWeek dayOfWeek = statusDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime().getDayOfWeek();
			
			String username = status.getUser().getScreenName();	
			
			PreparedStatement when = connection.prepareStatement("INSERT INTO Account_Posts_Post VALUES (?, ?, ?, ?, ?)");
			when.setString(1, username);
			when.setString(2, id);
			when.setString(3, dayOfWeek.toString());
			when.setDate(4, date);
			when.setTime(5, time);
			
			try {
				when.executeUpdate();
			} catch (MySQLIntegrityConstraintViolationException e) {
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			PreparedStatement post = connection.prepareStatement("INSERT INTO Post VALUES (?, ?, ?, ?)");
			post.setString(1, id);
			post.setInt(2, favoriteCount);
			post.setInt(3, retweetCount);
			post.setString(4, text);
			
			try {
				post.executeUpdate();
			} catch (MySQLIntegrityConstraintViolationException e) {
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	public void scrapeTweet(Status status) {
		try {
			String id = Long.toString(status.getId());
			HashtagEntity[] hashtags = status.getHashtagEntities();
			URLEntity[] links = status.getURLEntities();
			UserMentionEntity[] mentions = status.getUserMentionEntities();
			MediaEntity[] medias = status.getMediaEntities();
			
			String[] words = status.getText().split(" ");
			ArrayList<String> keywords = new ArrayList<String>();
			for (String word : words) {
				String keyword = getKeyWord(word);
				if (keyword != null && word.charAt(0) != '#' && word.charAt(0) != '@' &&
						(word.length() < 4 || (word.length() >= 4 && !(word.substring(0, 4).equals("http"))))) {
					keywords.add(keyword);
				}
			}
			
			for (HashtagEntity hashtag : hashtags) {
				String h = hashtag.getText();
				PreparedStatement ps = connection.prepareStatement("INSERT INTO Hashtag VALUES (?, ?)");
				ps.setString(1, id);
				ps.setString(2, h);
				
				try {
					ps.executeUpdate();
				} catch (MySQLIntegrityConstraintViolationException e) {
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			for (URLEntity link : links) {
				String l = link.getExpandedURL();
				PreparedStatement ps = connection.prepareStatement("INSERT INTO Link VALUES (?, ?)");
				ps.setString(1, id);
				ps.setString(2, l);
				
				try {
					ps.executeUpdate();
				} catch (MySQLIntegrityConstraintViolationException e) {
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			for (UserMentionEntity mention : mentions) {
				String m = mention.getScreenName();
				PreparedStatement ps = connection.prepareStatement("INSERT INTO Mention VALUES (?, ?)");
				ps.setString(1, id);
				ps.setString(2, m);
				
				try {
					ps.executeUpdate();
				} catch (MySQLIntegrityConstraintViolationException e) {
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			for (MediaEntity media : medias) {
				String m = media.getExpandedURL();
				PreparedStatement ps = connection.prepareStatement("INSERT INTO Media VALUES (?, ?)");
				ps.setString(1, id);
				ps.setString(2, m);
				
				try {
					ps.executeUpdate();
				} catch (MySQLIntegrityConstraintViolationException e) {
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			for (String keyword : keywords) {
				PreparedStatement ps = connection.prepareStatement("INSERT INTO Keyword VALUES (?, ?)");
				ps.setString(1, id);
				ps.setString(2, keyword);
				
				try {
					ps.executeUpdate();
				} catch (MySQLIntegrityConstraintViolationException e) {
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	public String getKeyWord(String word) {
		word = word.toLowerCase();
		int lastChar = word.length();
		for (int i = word.length() - 1; i >= 0; i--) {
			if (word.charAt(i) != '.' && word.charAt(i) != ',' && word.charAt(i) != '?'
					&& word.charAt(i) != ':' && word.charAt(i) != ';' && word.charAt(i) != '!') {
				break;
			}
			lastChar--;
		}
		word = word.substring(0, lastChar);
		if (word.equals("")) {
			return null;
		}
		for (int i = 0; i < word.length(); i++) {
			if (word.charAt(i) < 'a' || word.charAt(i) > 'z') {
				return null;
			}
		}
		if (noiseWords.contains(word)) {
			return null;
		}
		return word;
	}

}