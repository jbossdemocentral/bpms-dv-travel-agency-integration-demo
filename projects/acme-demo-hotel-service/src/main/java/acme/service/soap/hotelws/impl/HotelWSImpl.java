package acme.service.soap.hotelws.impl;


import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;
import java.util.Date;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.jws.WebService;

import acme.service.soap.hotelws.HotelRequest;
import acme.service.soap.hotelws.HotelWS;
import acme.service.soap.hotelws.Resort;

@WebService(serviceName = "HotelWS", endpointInterface = "acme.service.soap.hotelws.HotelWS", targetNamespace = "http://soap.service.acme/HotelWS/")
public class HotelWSImpl implements HotelWS {
	
	static Connection CONNECTION = null;
	
	static {
		createConnection();
	}
	public String bookHotel(String in) {
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

		SessionIdentifierGenerator bookingRef = new SessionIdentifierGenerator();
		String refNum = bookingRef.nextSessionId();
		
		createConnection();
		
		String sql = "INSERT INTO hotel_bookings(booking_id, hotel_id, arrive, depart ) VALUES(?, ?, ?, ?)";
		PreparedStatement statement =  null;
		try {
			statement = CONNECTION.prepareStatement(sql);
			
			statement.setString(1, refNum);
			statement.setInt(2, 10);
			
			 Date date;
			try {
				date = format.parse("2015-12-20" + " 00:00:00");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "";
			}
		
			statement.setTimestamp(3,  new java.sql.Timestamp(date.getTime()) );
			
			try {
				date = format.parse("2015-12-29" + " 00:00:00");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "";
			}

			statement.setTimestamp(4,  new java.sql.Timestamp(date.getTime()) );


			int results=statement.executeUpdate();
			
			statement.close();
		
			if (results == 0) {
				System.out.println("Insert issue, Hotel Request: " + in + " was not inserted");
			} else {
				System.out.println("Hotel Booked: " + in);
				System.out.println("Your RESERVATION NUMBER is: "+ refNum);
				System.out.println("SUCCESS: Your Hotel is now reserved.");
			}
	
			System.out.println("=========================================================================");

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (statement != null)
				try {
					statement.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		System.out.println("YOUR BOOKING HAS BEEN SUCCESSFUL");
		
		
		System.out.println("YOUR BOOKING REFERENCE IS: "+ refNum);
			
		
		return refNum;
	}

	
	public int cancelBooking(String in) {
		int cancelCharge = 0;
		final Random random = new Random();
		
		System.out.println("===== Hotel cancelBooking:" + in);

		
		if (in == null)
			throw new IllegalArgumentException("No hotel booking specified");
		
		createConnection();
		
		String sql = "DELETE from hotel_bookings WHERE booking_id = ?";
		PreparedStatement statement =  null;
		try {
			statement = CONNECTION.prepareStatement(sql);
			
			statement.setString(1, in);

			int results=statement.executeUpdate();
			
			statement.close();
		
			if (results == 0) {
				System.out.println("Booking for Ref " + in + " was not deleted");
			} else {
				System.out.println("Cancelled Booking for Ref: " + in);
			}
	
			System.out.println("=========================================================================");

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (statement != null)
				try {
					statement.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
			
		cancelCharge = random.nextInt((10-5)+1) + 5;		
		
		return cancelCharge;
	}
		

	public Resort getAvailableHotel(HotelRequest in) {
		System.out.println("===== getAvailableHotel:" + in.toString());

		Resort hotel = new Resort();
		
		String hotelCity = in.getTargetCity();	
		
			createConnection();
			
			
			String sql = "Select distinct hotel_id, hotel_name, rate, city from hotel_info where city = ? ";
		
			PreparedStatement statement = null;
			try {
				statement = CONNECTION.prepareStatement(sql);
				
				statement.setString(1, in.getTargetCity());
						
				ResultSet results=statement.executeQuery();
				
				int i=0;
				if (results.next()) {
					
					hotel.setHotelId(results.getInt(1));
					hotel.setHotelName(results.getString(2));
					hotel.setRatePerPerson(results.getDouble(3));
					hotel.setHotelCity(results.getString(4));
					hotel.setAvailableFrom(in.getStartDate());
					hotel.setAvailableTo(in.getEndDate());

					
					System.out.println("Available Hotel: - " + hotel.toString());
					
				}
				results.close();

				System.out.println("=========================================================================");
 
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				
				if (statement != null)
					try {
						statement.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		
			
			return hotel;
		
	}
	
	public static void createConnection() {
		if (CONNECTION != null) {
			if (isAlive()) return;
		}
		System.out.println("== Connecting to DV to pull federated data  ==============");
		String url = "jdbc:teiid:TravelVDB@mm://localhost:31100";
		try {
			Class.forName("org.teiid.jdbc.TeiidDriver");
			CONNECTION=DriverManager.getConnection(url,"teiidUser","admin_24");
		} catch (SQLException sqe) {
			sqe.printStackTrace();
			return;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return;
		}
	}
	
	private static boolean isAlive() {
		Statement s = null;
		try {
			s = CONNECTION.createStatement();
			s.execute("Select 1");
			return true;
		} catch (SQLException e) {
			CONNECTION = null;
			return false;
		} finally {
			try {
				if (s!=null) s.close();
			} catch (Exception e) {
				// do nothing
			}
		}
	}
}