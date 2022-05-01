package br.com.labbd.persistence;

import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
@Repository
public class GenericDao {
	private Connection c;

	public Connection getConnection() throws ClassNotFoundException, SQLException {
		String hostName = "192.168.0.103";
		String dbName = "paulista";
		String user = "makira";
		String password = "Kadeira2.0";

		String connect = 
				String.format("jdbc:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s",
						hostName, dbName, user, password);
		c = DriverManager.getConnection(connect);
		
		return c;
	}
}
