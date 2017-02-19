
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.net.InetSocketAddress;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.channels.CompletionHandler;
import java.nio.channels.FileChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.attribute.BasicFileAttributeView;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.UserDefinedFileAttributeView;
import java.nio.file.attribute.FileTime;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitOption;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.nio.MappedByteBuffer;
import java.util.Arrays;
import java.util.Calendar;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Snippet {

	/*Crear un archivo*/
	public void createFile() {
		File fileFromPath = Paths.get("prueba.txt").toFile();
	}

	/*Obtener la ruta relativa de un archivo*/
	public void resolveRelativePath() {
		Path directory = Paths.get("C:/");
		Path pathInDirectory = directory.resolve("prueba.txt");
	}

	/*Eliminar un archivo*/
	public void deleteIfExists() {
		Path path = Paths.get("prueba.txt");
		try {
			Files.deleteIfExists(path);
		} catch (IOException e) {
			//TODO: Manejar excepcion
		}
	}

	/*Escribir en un archivo*/
	public void writeFile() {
		List<String> lines = Arrays.asList(String.valueOf(Calendar.getInstance().getTimeInMillis()), "linea de prueba",
				"linea de prueba 2");

		try {
			Path path = Paths.get("prueba.txt");
			OutputStream outputStream = Files.newOutputStream(path, StandardOpenOption.CREATE_NEW);
			for (String line : lines) {
				outputStream.write((line + System.lineSeparator()).getBytes(StandardCharsets.UTF_8));
			}

		} catch (Exception e) {
			//TODO: Manejar excepcion
		}
	}

	/*Recorrer los archivos de un directorio*/
	public void iterateFolderFiles() {

		try {
			Path directorio = Paths.get("C:/");
			Files.walkFileTree(directorio, EnumSet.noneOf(FileVisitOption.class), 1, new SimpleFileVisitor<Path>() {
				@Override
				public FileVisitResult preVisitDirectory(Path selectedPath, BasicFileAttributes attrs)
						throws IOException {
					System.out.println("Directorio " + selectedPath.toAbsolutePath());
					return FileVisitResult.CONTINUE;
				}

				public FileVisitResult visitFile(Path selectedPath, BasicFileAttributes attrs) throws IOException {
					System.out.println("file " + selectedPath.toAbsolutePath());
					return FileVisitResult.CONTINUE;
				}
			});
		} catch (IOException e) {
			//TODO: Manejar excepcion
		}
	}


	/*Copiar contenido de un archivo*/
	public void CopyFile() {
		File sourceFile = new File("prueba.txt");
		File destFile = new File("prueba.txt");
		if (!sourceFile.exists() || !destFile.exists()) {
			// Source or destination file doesn't exist
			return;
		}
		
		try {
			FileInputStream fis = new FileInputStream(sourceFile);
			FileOutputStream fos = new FileOutputStream(destFile);
			FileChannel srcChannel = fis.getChannel();
			FileChannel sinkChanel = fos.getChannel();

			try {
				srcChannel.transferTo(0, srcChannel.size(), sinkChanel);
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (srcChannel != null) {
					srcChannel.close();
				}
				if (sinkChanel != null) {
					sinkChanel.close();
				}

				if (fis != null) {
					fis.close();
				}

				if (fos != null) {
					fos.close();
				}
			}

		} catch (Exception e) {
			//TODO: Manejar excepcion
		}
	}
	
	/*Crear acceso directo a un archivo*/
	public void createLink() {
	    final String rutaACrearAcceso = "D://";//Ruta donde se creara el acceso directo
	    final String rutaArchivoExistente = "D://prueba.txt";
	    final Path accesoDirecto = FileSystems.getDefault().getPath(rutaACrearAcceso);
	    final Path archivoExistente = FileSystems.getDefault().getPath(rutaArchivoExistente);
	    
	    try {
	        Files.createLink(accesoDirecto, archivoExistente);
	    } catch (final UnsupportedOperationException ooe) {
	        //TODO: Manejar excepcion
	    }
	    catch(IOException ioe){
	    	//TODO: Manejar excepcion
	    }
	}
	
	/*Verificar si un archivo es oculto*/
	public void isHidden(){
	    String path = "D://prueba.txt";
	    try {
	    	boolean isHidden = Files.isHidden(FileSystems.getDefault().getPath(path));
		} catch (IOException ioe) {
			//TODO: Manejar excepcion
		}
	}
	
	/*Convierte la ruta absoluta en relativa*/
	public void relativizeSuperset() {
	    Path path = FileSystems.getDefault().getPath("/a/b");
	    Path other = FileSystems.getDefault().getPath("/a/b/c/d");
	    Path relativized = path.relativize(other);//retorna c\d
	}
	
	/*Borrar subcarpetas y archivos de forma recursiva*/
	public void deleteRecursively() {
		Path path = FileSystems.getDefault().getPath("D://DirectorioABorrar");
		try {
			Files.walkFileTree(path, new SimpleFileVisitor<Path>() {
				@Override
				public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
					Files.delete(file);
					return FileVisitResult.CONTINUE;
				}
				
				@Override
				public FileVisitResult postVisitDirectory(Path dir, IOException e) throws IOException {
					if (e == null) {
						Files.delete(dir);
						return FileVisitResult.CONTINUE;
					} else {
						throw e;
					}
				}
			});
		} catch (IOException e) {
			// TODO: Manejar excepcion
		}
	}
	
	/*Buscar un archivo en un directorio y sus subdirectorios*/
	public boolean fileExists() {
	    Path start = FileSystems.getDefault().getPath("D://");
	    String name = "prueba.txt";
	    final AtomicBoolean exist = new AtomicBoolean();
	    try {
			Files.walkFileTree(start, new SimpleFileVisitor<Path>() {

			    @Override
			    public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) throws IOException {
			        if (name.equals(file.getFileName().toString())) {
			            exist.set(true);
			            return FileVisitResult.TERMINATE;
			        } else {
			            return FileVisitResult.CONTINUE;
			        }
			    }
			});
		} catch (IOException e) {
			// TODO: Manejar excepcion
		}
	    return exist.get();
	}
	
	/*Hacer seguimiento a la creacion de archivos*/
	public void watchEvents() {
		Path this_dir = Paths.get(".");
		try {
			WatchService watcher = this_dir.getFileSystem().newWatchService();
			this_dir.register(watcher, StandardWatchEventKinds.ENTRY_CREATE);

			WatchKey watckKey = watcher.take();

			List<WatchEvent<?>> events = watckKey.pollEvents();
			for (WatchEvent<?> event : events) {
				System.out.println("Nuevo archivo creado '" + event.context().toString() + "'.");

			}
		} catch (Exception e) {
			// TODO: Manejar excepcion
		}
	}
	
	/*Leer y escribir de un archivo mapeado en memoria*/
	public void memoryMapping() {
		int mem_map_size = 20 * 1024 * 1024;
		String fn = "prueba.txt";
		RandomAccessFile memoryMappedFile;
		try {
			memoryMappedFile = new RandomAccessFile(fn, "rw");
			// Mapear el archivo en memoria
			MappedByteBuffer out;
			out = memoryMappedFile.getChannel().map(FileChannel.MapMode.READ_WRITE, 0, mem_map_size);
			
			// Escribir en el archivo mapeado en memoria
			for (int i = 0; i < mem_map_size; i++) {
				out.put((byte) 'A');
			}
			
			// Leer desde el archivo mapeado en memoria
			for (int i = 0; i < 30; i++) {
				System.out.print((char) out.get(i));
			}
			
		} catch (FileNotFoundException e) {
			// TODO: Manejar excepcion

		} catch (IOException e) {
			// TODO: Manejar excepcion
		}
	}
	
	/*Leer archivo*/
	public void readFile() {
		Path file = null;
		BufferedReader bufferedReader = null;
		try {
			file = Paths.get("D://prueba.txt");
			InputStream inputStream = Files.newInputStream(file);
			bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
			System.out.println("Contenido de la linea: " + bufferedReader.readLine());
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				bufferedReader.close();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
	}
	
	/*Leer archivo usando FileChannel*/
	public void readFileUsingFileChannel() {
		RandomAccessFile file = null;
		try {
			file = new RandomAccessFile("D://prueba.txt", "r");
			FileChannel fileChannel = file.getChannel();
			ByteBuffer buffer = ByteBuffer.allocate(24);
			int bytes = fileChannel.read(buffer);
			bytes = fileChannel.read(buffer);
			while (bytes != -1) {
				buffer.flip();

				while (buffer.hasRemaining()) {
					System.out.print((char) buffer.get());
				}

				buffer.clear();
				bytes = fileChannel.read(buffer);

			}

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				file.close();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
	}
	
	/*Escribir archivo de forma asincrona*/
	public void writeFileAsynchronously() {
		Path file = null;
		AsynchronousFileChannel asynchFileChannel = null;
		String filePath = "D://prueba.txt";
		try {
			file = Paths.get(filePath);
			asynchFileChannel = AsynchronousFileChannel.open(file, StandardOpenOption.WRITE, StandardOpenOption.CREATE);

			CompletionHandler<Integer, Object> handler = new CompletionHandler<Integer, Object>() {
				@Override
				public void completed(Integer result, Object attachment) {
					// Escritura de archivo completada
				}

				@Override
				public void failed(Throwable e, Object attachment) {
					// Error al escribir en el archivo
				}
			};

			asynchFileChannel.write(ByteBuffer.wrap("texto a escribir.".getBytes()), 0, "File Write", handler);
		} catch (IOException e) {
			//TODO: Manejar excepcion
		} finally {
			try {
				asynchFileChannel.close();
			} catch (IOException ioe) {
				//TODO: Manejar excepcion
			}
		}
	}
	
	/*Buscar archivos en directorio*/
	public void searchDirectory() {
		String directorio = "C://";
		String patron = "ArchivosABuscar";
		DirectoryStream<Path> directoryStream = null;
		try {
			directoryStream = Files.newDirectoryStream(Paths.get(directorio), patron);
			for (Path path : directoryStream) {
				System.out.println("Archivos/Directorios encontrados " + patron + ": " + path.toString());
			}
		} catch (IOException ioe) {
			// TODO: Manejar excepcion
		} finally {
			try {
				directoryStream.close();
			} catch (IOException ioe) {
				// TODO: Manejar excepcion
			}
		}
	}
	
	/*Ver si una ruta apunta a archivo o directorio*/
	public void checkIfDirectory() {
		Path file = null;
		try {
			file = Paths.get("C://");
			BasicFileAttributeView basicfileAttribView = Files.getFileAttributeView(file, BasicFileAttributeView.class, LinkOption.NOFOLLOW_LINKS);
			BasicFileAttributes basicFileAttributes = basicfileAttribView.readAttributes();
			System.out.println("Es directorio:  " + basicFileAttributes.isDirectory());

		} catch (IOException e) {
			// TODO: Manejar excepcion
		}
	}
	
	/*Inicializar servidor*/
	public void initServer() {
		String address = "127.0.0.1";
	    int port = 8511;
	     
	    ServerSocketChannel serverChannel;
	    Selector selector;
        
        try {
            // Abrir un selector y un ServerSocketChannel
            selector = Selector.open();
            serverChannel = ServerSocketChannel.open();
            
            // Configurar un ServerSocketChannel como non-blocking.
            serverChannel.configureBlocking(false);
            // enlazar a la direccion del servidor
            serverChannel.socket().bind(new InetSocketAddress(address, port));
 
            //Registrar el serverSocketChannel para aceptar conexiones
            serverChannel.register(selector, SelectionKey.OP_ACCEPT);
 
        } catch (IOException e) {
        	// TODO: Manejar excepcion
        }
	}
	
	/*Codificar y decodificar charset*/
	public void charsetEncodingDecoding() {
		Charset charset = Charset.forName("US-ASCII");
		System.out.println(charset.displayName());
		System.out.println(charset.canEncode());
		String texto = "Ejemplo de charset.";
		//Convertir el byte buffer en el charset de entrada a un char buffer unicode
		ByteBuffer buffer = ByteBuffer.wrap(texto.getBytes());
		CharBuffer charBuffer = charset.decode(buffer);
		//Convertir char buffer en unicode a un byte buffer en el charset de entrada
		ByteBuffer nuevoBuffer = charset.encode(charBuffer);
		while (nuevoBuffer.hasRemaining()) {
			char caracteres = (char) nuevoBuffer.get();
			System.out.print(caracteres);
		}
		nuevoBuffer.clear();
	}
	
	/*Cambiar la fecha de ultimo acceso a un archivo*/
	public void changeLastAccessTimestamp() {	    
        Path path = Paths.get("C:", "prueba.txt");
        long fechaHoraActual = System.currentTimeMillis();
        FileTime fechaHoraArchivo = FileTime.fromMillis(fechaHoraActual);
        try {
			Files.setAttribute(path, "basic:lastAccessTime", fechaHoraArchivo, java.nio.file.LinkOption.NOFOLLOW_LINKS);
		} catch (IOException e) {
			// TODO: Manejar excepcion
		}
	}
	
	/*Mover archivo*/
	public void moveFile() {	    
		File fromFolder = new File("C:\\rutaOrigen");
        File toFolder = new File("C:\\rutaDestino");
        
        //StandardCopyOption.ATOMIC_MOVE Mueve el archivo mediante una operacion atomica de sistema de archivos
        //StandardCopyOption.REPLACE_EXISTING - Si existe un archivo con el mismo nombre, lo reemplaza
        //StandardCopyOption.COPY_ATTRIBUTES - Copia los atributos al nuevo archivo
        try {
            Files.move(fromFolder.toPath(), toFolder.toPath(), 
                    StandardCopyOption.ATOMIC_MOVE,
                    StandardCopyOption.REPLACE_EXISTING,
                    StandardCopyOption.COPY_ATTRIBUTES
                    );
            
        } catch (IOException e) {
        	// TODO: Manejar excepcion
        }
	}
	
	/*Leer y escribir atributos personalizados de un archivo*/
	public void readWriteCustomAttribute() {	    
		Path file = FileSystems.getDefault().getPath("D://prueba.txt");

	    UserDefinedFileAttributeView view = Files.getFileAttributeView(file, UserDefinedFileAttributeView.class);

	    String nombreAtributo = "atributo.personalizado";
	    String valorAtributo = "valor de prueba";

	    try {
			byte[] bytes = valorAtributo.getBytes("UTF-8");
			 final ByteBuffer writeBuffer = ByteBuffer.allocate(bytes.length);
			    writeBuffer.put(bytes);
			    writeBuffer.flip();
			    view.write(nombreAtributo, writeBuffer);

			    // Leer la propiedad
			    final ByteBuffer readBuffer = ByteBuffer.allocate(view.size(nombreAtributo));
			    view.read(nombreAtributo, readBuffer);
			    readBuffer.flip();
			    final String valueFromAttributes = new String(readBuffer.array(), "UTF-8");
			    System.out.println("Atributo personalizado: " + valueFromAttributes);
		} catch (UnsupportedEncodingException e) {
			//TODO: Manejar excepcion
		} catch (IOException e) {
			//TODO: Manejar excepcion
		}	   
	}
	
	/*Modificar los permisos de un archivo*/
	public void setFilePermissions() {	    
		Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
        //Dar permisos al dueño del archivo
        perms.add(PosixFilePermission.OWNER_READ);
        perms.add(PosixFilePermission.OWNER_WRITE);
        perms.add(PosixFilePermission.OWNER_EXECUTE);
        //Dar permisos al grupo
        perms.add(PosixFilePermission.GROUP_READ);
        perms.add(PosixFilePermission.GROUP_WRITE);
        perms.add(PosixFilePermission.GROUP_EXECUTE);
        //Dar permisos a otros usuarios
        perms.add(PosixFilePermission.OTHERS_READ);
        perms.add(PosixFilePermission.OTHERS_WRITE);
        perms.add(PosixFilePermission.OTHERS_EXECUTE);
        
        try {
			Files.setPosixFilePermissions(Paths.get("D://prueba.txt"), perms);
		} catch (IOException e) {
			//TODO: Manejar excepcion
		}
	}
	
	/*Leer archivo de forma asincrona*/
	public void readFileAsynchronously() {
		ByteBuffer buffer = ByteBuffer.allocate(1000);

		Path path = FileSystems.getDefault().getPath("RutaDeArchivoExistente");

		try (AsynchronousFileChannel asyncChannel = AsynchronousFileChannel.open(path)) {

			Future<Integer> fileResult = asyncChannel.read(buffer, 0);
			
			while (!fileResult.isDone()) {
				System.out.println("En espera de completar la lectura del archivo ...");
			}

			//Reiniciar la posicion actual del buffer				
			buffer.flip();

			// Decodificar y mostrar el contenido del byte buffer
			System.out.println(Charset.defaultCharset().decode(buffer));
			

		} catch (IOException ex) {
			// TODO: Manejar excepcion
		}
	}
}
