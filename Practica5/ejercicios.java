import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.DriverManager;
import java.sql.*;
import java.util.Scanner;


public class ejercicios {

   private Connection conexion = null;

    public static void main(String[] args) throws IOException {
        
        ejercicios ejercicios = new ejercicios();
        ejercicios.conectarseBaseDatos();
        ejercicios.consulta();
          
    }
    
    public void conectarseBaseDatos() throws IOException{ 

        //String nombreBaseDatos, usuario, contraseña;
        Statement statement = null;
        
        try{
            try{
            Class.forName("com.mysql.jdbc.Driver");
            }catch (ClassNotFoundException e) {
                System.out.println("Error al registrar el drive: "+e);
            }

            System.out.println("Acceso a la base de datos...");

            
            conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "usuarioROOT", "Axel@valladares1");
            statement = conexion.createStatement();

            boolean valido = conexion.isValid(50000);

            if(valido == true){
                System.out.println("Conexion establecida correctamente \n");
            }else {
                System.out.println("Fallo al intentar establecer la conexion \n");
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }

        return;

    }

    public void consulta() throws IOException{
        
        Statement stmtSelect;
        ResultSet stmtResult;

        try{

            PreparedStatement stmt = conexion.prepareStatement("CREATE DATABASE IF NOT EXISTS misPeliculas");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("USE misPeliculas");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("DROP TABLE IF EXISTS Directores;");
            stmt.executeUpdate();
            stmt = conexion.prepareStatement("DROP TABLE IF EXISTS ActoresPeliculas;");
            stmt.executeUpdate();
            stmt = conexion.prepareStatement("DROP TABLE IF EXISTS Peliculas;");
            stmt.executeUpdate();
            stmt = conexion.prepareStatement("DROP TABLE IF EXISTS Actores;");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("CREATE TABLE Peliculas(" +
                    "ID_peliculas INT ," +
                    "titulo VARCHAR(50)," +
                    "ID_director INT NOT NULL," +
                    "PRIMARY KEY(ID_peliculas)," +
                    "UNIQUE (ID_peliculas, titulo)" +
                    ");");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("CREATE INDEX IndiceDirectores ON Peliculas(ID_director);");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("CREATE TABLE Directores(" +
                    "ID_director INT UNIQUE," +
                    "edad INT CHECK (edad > 0 AND edad <= 120)," +
                    "nombre VARCHAR(50) NOT NULL," +
                    "PRIMARY KEY(ID_director)," +
                    "FOREIGN KEY(ID_director) REFERENCES Peliculas(ID_director)" +
                    ");");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement(
                    "CREATE TABLE Actores (ID_actor INT UNIQUE,edad INT CHECK (edad > 0 AND edad <= 120),nombre VARCHAR(50) NOT NULL ,PRIMARY KEY(ID_actor));");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("CREATE TABLE ActoresPeliculas(" +
                    "ID_actor INT," +
                    "ID_peliculas INT," +
                    "PRIMARY KEY (ID_actor, ID_peliculas)," +
                    "FOREIGN KEY (ID_actor) REFERENCES Actores (ID_actor)," +
                    "FOREIGN KEY (ID_peliculas) REFERENCES Peliculas (ID_peliculas)" +
                    ");");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("INSERT INTO Peliculas (ID_peliculas, titulo, ID_director) VALUES" +
                    "(0172495, 'gladiator', 631)," +
                    "(0371746, 'iron Man', 939)," +
                    "(6320628, 'spiderMan', 939)," +
                    "(4154796, 'los vengadores: Endgame', 939)," +
                    "(816692,  'interstellar', 4240)," +
                    "(76759,   'star Wars: A new hope', 184)," +
                    "(3659388, 'the Martian', 631)," +
                    "(123456, 'rodolfo en la ciudad', 631);");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("INSERT INTO Directores (nombre, ID_director, edad) VALUES" +
                    "('Ridley Scott', 631, 83)," +
                    "('Marvel - Hermanos Russo', 939, 85)," +
                    "('Christopher Nolan', 4240, 50)," +
                    "('George Lucas', 184, 75);");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement(
                    "INSERT INTO Actores (nombre,ID_actor, edad) VALUES('Russell Crowe', 128, 56),('Robert Downey Jr', 375, 55),('Tom Holland', 618, 24),('Gwyneth Paltrow', 569, 48),('Matthew McConaughey', 190, 52),('Matt Damon', 354, 51),('Mark Hamill', 434, 70),('Carrie Fisher', 402, 60),('Harrison Ford', 148, 79),('Hayden Christensen', 789, 50);");
            stmt.executeUpdate();

            stmt = conexion.prepareStatement("INSERT INTO ActoresPeliculas (ID_actor, ID_peliculas) VALUES" +
                    "(128,0172495),(375,0371746),(375,4154796)," +
                    "(618,6320628),(618,4154796),(569,0371746)," +
                    "(569,4154796),(190,816692),(354,816692)," +
                    "(434,76759),(402,76759),(148,76759),(354,3659388);");

            stmt.executeUpdate();

            System.out.println("Funcion completada");
            
            Scanner leerComando = new Scanner(System.in);
            int opcion;
            System.out.println("Introduzca una operacion: ");
            System.out.println("1.Crear una tupla de peliculas");
            System.out.println("2.Consultas del ejercicio 8 Practica2");
            System.out.println("3.Poner en mayuscula la primera letra de los titulos de las peliculas");
            opcion = leerComando.nextInt();
            
            switch (opcion) {

                case 1: 
                
                    BufferedReader leer = new BufferedReader(new InputStreamReader(System.in));

                    String ID_pelicula, titulo, ID_director;

                    System.out.println("Introduzca la tupla a añadir en Peliculas:\n");
                    System.out.println("ID_pelicula: ");
                    ID_pelicula = leer.readLine();
                    System.out.println("\nTitulo: ");
                    titulo = leer.readLine();
                    System.out.println("\nID_director: ");
                    ID_director = leer.readLine();

                    PreparedStatement stmtNuevo = conexion.prepareStatement("INSERT INTO Peliculas (ID_peliculas, titulo, ID_director) VALUES('"+ID_pelicula.trim()+"', '"+titulo.trim()+"', '"+ID_director.trim()+"');");
                    stmtNuevo.executeUpdate();
                    
                    System.out.println("Insertada la tupla con exito");
                    break;

                case 2:

                    System.out.println("Elije una opcion :");
                    System.out.println("1.Listar todos los actores");
                    System.out.println("2.Todos los actores de Star Wars");
                    System.out.println("3.Actores de edad > 50 años");
                    opcion = leerComando.nextInt();

                    switch(opcion) {

                        case 1:
                            stmtSelect = conexion.createStatement();
                            stmtResult = stmtSelect.executeQuery("SELECT * FROM Actores;");
                            while(stmtResult.next()) {
                                System.out.println(stmtResult.getString("nombre") + ", " + stmtResult.getString("ID_actor") + ", " + stmtResult.getString("edad"));
                            }
                            break;

                        case 2:
                            stmtSelect = conexion.createStatement();
                            stmtResult = stmtSelect.executeQuery("SELECT * FROM Actores, ActoresPeliculas, Peliculas WHERE Actores.ID_actor = ActoresPeliculas.ID_actor and Peliculas.ID_peliculas = ActoresPeliculas.ID_peliculas and Peliculas.titulo = 'Star Wars: A new hope';");
                            while(stmtResult.next()) {
                                System.out.println(stmtResult.getString(("nombre")));
                            }
                            break;

                        case 3:
                            stmtSelect = conexion.createStatement();
                            stmtResult = stmtSelect.executeQuery("SELECT * FROM Actores WHERE edad > 50;");
                            while (stmtResult.next()) {
                                System.out.println(stmtResult.getString("nombre") + "      " +"edad: " + stmtResult.getString("edad"));
                            }
                            break;       
                    }

                    case 3:
                        stmtSelect = conexion.createStatement();
                        stmtResult = stmtSelect.executeQuery("SELECT titulo FROM Peliculas;");
                        while(stmtResult.next()) {

                            String cadena = stmtResult.getString(("titulo"));
                            String cadenaMayus = "", cadenaFinal="", CADENA="";
                            cadenaMayus=cadena.toUpperCase();
                            for(int i = 1; i<cadena.length(); i++) {
                                    CADENA = CADENA+cadena.charAt(i);
                                }
                                cadenaFinal = cadenaMayus.charAt(0)+CADENA;
                                
                                System.out.println(cadenaFinal);
                                
     
                                
                            }

                        break;


                    default:
                        System.out.println("Opcion no contemplada");

                    break;
            }

        }catch(SQLException e) {
            e.getErrorCode();
        }

    }


    public static String recogerDatos(int opcion) {

        Scanner leerComando = new Scanner(System.in);

        switch(opcion) {

            case 1:
                System.out.println("Introduzca el nombre de la base de datos : ");
                return leerComando.nextLine();

            case 2:
                System.out.println("Introduzca el nombre del usuario :");
                return leerComando.nextLine();

            case 3:
                System.out.println("Introduzca la contraseña :");
                return leerComando.nextLine();

            default:
                return "";
        }
    }







}