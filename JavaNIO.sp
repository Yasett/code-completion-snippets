
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

	/*Create a file*/
	public void createFile() {
		File fileFromPath = Paths.get("file_path.ext").toFile();
	}

	/*Get the relative path of a file*/
	public void resolveRelativePath() {
		Path directory = Paths.get("C://");
		Path pathInDirectory = directory.resolve("file_path.ext");
	}

	/*Delete a file*/
	public void deleteIfExists() {
		Path path = Paths.get("file_path.ext");
		try {
			Files.deleteIfExists(path);
		} catch (IOException e) {
			//TODO: Handle exception
		}
	}

	/*Write in a file*/
	public void writeFile() {
		List<String> lines = Arrays.asList(String.valueOf(Calendar.getInstance().getTimeInMillis()), "linea de prueba",
				"linea de prueba 2");

		try {
			Path path = Paths.get("file_path.ext");
			OutputStream outputStream = Files.newOutputStream(path, StandardOpenOption.CREATE_NEW);
			for (String line : lines) {
				outputStream.write((line + System.lineSeparator()).getBytes(StandardCharsets.UTF_8));
			}

		} catch (Exception e) {
			//TODO: Handle exception
		}
	}

	/*Iterate through the files and subfolders of a folder*/
	public void iterateFolderFiles() {

		try {
			Path folder = Paths.get("C:/");
			
			Files.walkFileTree(folder, EnumSet.noneOf(FileVisitOption.class), 1, new SimpleFileVisitor<Path>() {
				@Override
				public FileVisitResult preVisitDirectory(Path selectedPath, BasicFileAttributes attrs)
						throws IOException {
					System.out.println("Folder " + selectedPath.toAbsolutePath());
					return FileVisitResult.CONTINUE;
				}

				public FileVisitResult visitFile(Path selectedPath, BasicFileAttributes attrs) throws IOException {
					System.out.println("File " + selectedPath.toAbsolutePath());
					return FileVisitResult.CONTINUE;
				}
			});
		} catch (IOException e) {
			//TODO: Handle exception
		}
	}


	/*Copy the contents of a file*/
	public void CopyFile() {
		File sourceFile = new File("file_path.ext");
		File destFile = new File("file_path.ext");
		if (!sourceFile.exists() || !destFile.exists()) {
			// Source or destination file doesn't exist
			return;
		}
		
		try (FileInputStream fis = new FileInputStream(sourceFile);
				FileOutputStream fos = new FileOutputStream(destFile);
				FileChannel srcChannel = fis.getChannel();
				FileChannel sinkChanel = fos.getChannel();) {			
				
				srcChannel.transferTo(0, srcChannel.size(), sinkChanel);

			
		} catch (Exception e) {
			//TODO: Handle exception
		}
	}
	
	/*Create a link to a file*/
	public void createLink() {
	    final String linkPath = "D://"; //Path where the link will be created
	    final String existingFilePath = "D://file_path.ext";
	    final Path link = FileSystems.getDefault().getPath(linkPath);
	    final Path existingFile = FileSystems.getDefault().getPath(existingFilePath);
	    
	    try {
	        Files.createLink(link, existingFile);
	    } catch (final UnsupportedOperationException ooe) {
	        //TODO: Handle exception
	    }
	    catch(IOException ioe){
	    	//TODO: Handle exception
	    }
	}
	
	/*Verify if a file is hidden*/
	public void isHidden(){
	    String path = "D://file_path.ext";
	    try {
	    	boolean isHidden = Files.isHidden(FileSystems.getDefault().getPath(path));
		} catch (IOException ioe) {
			//TODO: Handle exception
		}
	}
	
	/*Convert absolute path into relative path*/
	public void relativizeSuperset() {
	    Path path = FileSystems.getDefault().getPath("/a/b");
	    Path other = FileSystems.getDefault().getPath("/a/b/c/d");
	    Path relativePath = path.relativize(other);//returns c\d
	}
	
	/*Delete subfolder and files recursively*/
	public void deleteRecursively() {
		Path path = FileSystems.getDefault().getPath("D://folder_path");
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
			// TODO: Handle exception
		}
	}
	
	/*Search file in folder and subfolders*/
	public boolean fileExists() {
	    Path start = FileSystems.getDefault().getPath("D://");
	    String name = "file_path.ext";
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
			// TODO: Handle exception
		}
	    return exist.get();
	}
	
	/*Register watcher for the creation of files*/
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
			// TODO: Handle exception
		}
	}
	
	/*Read and write a memory mapped file*/
	public void memoryMapping() {
		int mem_map_size = 20 * 1024 * 1024;
		String fn = "file_path.ext";
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
			// TODO: Handle exception

		} catch (IOException e) {
			// TODO: Handle exception
		}
	}
	
	/*Read file*/
	public void readFile() {
		Path file = null;
		BufferedReader bufferedReader = null;
		try {
			file = Paths.get("D://file_path.ext");
			InputStream inputStream = Files.newInputStream(file);
			bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
			System.out.println("Line content: " + bufferedReader.readLine());
		} catch (IOException e) {
			// TODO: Handle exception
		} finally {
			try {
				bufferedReader.close();
			} catch (IOException ioe) {
				// TODO: Handle exception
			}
		}
	}
	
	/*Rea file using FileChannel*/
	public void readFileUsingFileChannel() {
		RandomAccessFile file = null;
		try {
			file = new RandomAccessFile("D://file_path.ext", "r");
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
			// TODO: Handle exception
		} finally {
			try {
				file.close();
			} catch (IOException ioe) {
				// TODO: Handle exception
			}
		}
	}
	
	/*Write file Asynchronously*/
	public void writeFileAsynchronously() {
		Path file = null;
		AsynchronousFileChannel asynchFileChannel = null;
		String filePath = "D://file_path.ext";
		try {
			file = Paths.get(filePath);
			asynchFileChannel = AsynchronousFileChannel.open(file, StandardOpenOption.WRITE, StandardOpenOption.CREATE);

			CompletionHandler<Integer, Object> handler = new CompletionHandler<Integer, Object>() {
				@Override
				public void completed(Integer result, Object attachment) {
					// Writing operation completed
				}

				@Override
				public void failed(Throwable e, Object attachment) {
					// Writing operation failed
				}
			};

			asynchFileChannel.write(ByteBuffer.wrap("text_to_write".getBytes()), 0, "File Write", handler);
		} catch (IOException e) {
			//TODO: Handle exception
		} finally {
			try {
				asynchFileChannel.close();
			} catch (IOException ioe) {
				//TODO: Handle exception
			}
		}
	}
	
	/*Search files and folders*/
	public void searchDirectory() {
		String folder = "C://";
		String pattern = "*.{java,class,jar}";
		DirectoryStream<Path> directoryStream = null;
		try {
			directoryStream = Files.newDirectoryStream(Paths.get(folder), pattern);
			for (Path path : directoryStream) {
				System.out.println("Files/folders found " + pattern + ": " + path.toString());
			}
		} catch (IOException ioe) {
			// TODO: Handle exception
		} finally {
			try {
				directoryStream.close();
			} catch (IOException ioe) {
				// TODO: Handle exception
			}
		}
	}
	
	/*Check if a path points to a file or folder*/
	public void checkIfDirectory() {
		Path file = null;
		try {
			file = Paths.get("C://");
			BasicFileAttributeView basicfileAttribView = Files.getFileAttributeView(file, BasicFileAttributeView.class, LinkOption.NOFOLLOW_LINKS);
			BasicFileAttributes basicFileAttributes = basicfileAttribView.readAttributes();
			System.out.println("Is folder  " + basicFileAttributes.isDirectory());

		} catch (IOException e) {
			// TODO: Handle exception
		}
	}
	
	/*Init server*/
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
        	// TODO: Handle exception
        }
	}
	
	/*Code and decode charset*/
	public void charsetEncodingDecoding() {
		Charset charset = Charset.forName("US-ASCII");
		System.out.println(charset.displayName());
		System.out.println(charset.canEncode());
		String texto = "Charset example.";
		//Convert the byte buffer into the input charset of a unicode char buffer
		ByteBuffer buffer = ByteBuffer.wrap(texto.getBytes());
		CharBuffer charBuffer = charset.decode(buffer);
		//Convert the unicode char buffer into a byte buffer in the input charset 
		ByteBuffer newBuffer = charset.encode(charBuffer);
		while (newBuffer.hasRemaining()) {
			char chars = (char) newBuffer.get();
			System.out.print(chars);
		}
		newBuffer.clear();
	}
	
	/*Change last access date of a file*/
	public void changeLastAccessTimestamp() {	    
        Path path = Paths.get("C:", "file_path.ext");
        long fechaHoraActual = System.currentTimeMillis();
        FileTime fechaHoraArchivo = FileTime.fromMillis(fechaHoraActual);
        try {
			Files.setAttribute(path, "basic:lastAccessTime", fechaHoraArchivo, java.nio.file.LinkOption.NOFOLLOW_LINKS);
		} catch (IOException e) {
			// TODO: Handle exception
		}
	}
	
	/*Move file*/
	public void moveFile() {	    
		File fromFolder = new File("C://origin_file_path.ext");
        File toFolder = new File("C://target_file_path.ext");
        
        //StandardCopyOption.ATOMIC_MOVE Moves the file with an atomic file system operation
        //StandardCopyOption.REPLACE_EXISTING - Replaces existing files with the same name
        //StandardCopyOption.COPY_ATTRIBUTES - Copies the attributes to the new file
        try {
            Files.move(fromFolder.toPath(), toFolder.toPath(), 
                    StandardCopyOption.ATOMIC_MOVE,
                    StandardCopyOption.REPLACE_EXISTING,
                    StandardCopyOption.COPY_ATTRIBUTES
                    );
            
        } catch (IOException e) {
        	// TODO: Handle exception
        }
	}
	
	/*Read and write custom attributes of a file*/
	public void readWriteCustomAttribute() {	    
		Path file = FileSystems.getDefault().getPath("D://file_path.ext");

	    UserDefinedFileAttributeView view = Files.getFileAttributeView(file, UserDefinedFileAttributeView.class);

	    String nombreAtributo = "custom_attribute";
	    String valorAtributo = "sample_value";

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
			    System.out.println("Custom attribute: " + valueFromAttributes);
		} catch (UnsupportedEncodingException e) {
			//TODO: Handle exception
		} catch (IOException e) {
			//TODO: Handle exception
		}	   
	}
	
	/*Set file permissions*/
	public void setFilePermissions() {	    
		Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
        //Grant access to the file owner
        perms.add(PosixFilePermission.OWNER_READ);
        perms.add(PosixFilePermission.OWNER_WRITE);
        perms.add(PosixFilePermission.OWNER_EXECUTE);
        //Grant access to the group
        perms.add(PosixFilePermission.GROUP_READ);
        perms.add(PosixFilePermission.GROUP_WRITE);
        perms.add(PosixFilePermission.GROUP_EXECUTE);
        //Grant access to other users
        perms.add(PosixFilePermission.OTHERS_READ);
        perms.add(PosixFilePermission.OTHERS_WRITE);
        perms.add(PosixFilePermission.OTHERS_EXECUTE);
        
        try {
			Files.setPosixFilePermissions(Paths.get("D://file_path.ext"), perms);
		} catch (IOException e) {
			//TODO: Handle exception
		}
	}
	
	/*Read file asynchronously*/
	public void readFileAsynchronously() {
		ByteBuffer buffer = ByteBuffer.allocate(1000);

		Path path = FileSystems.getDefault().getPath("D://file_path.ext");

		try (AsynchronousFileChannel asyncChannel = AsynchronousFileChannel.open(path)) {

			Future<Integer> fileResult = asyncChannel.read(buffer, 0);
			
			while (!fileResult.isDone()) {
				System.out.println("Waiting until file reading is complete ...");
			}

			//Restart the buffer current position				
			buffer.flip();

			// Decode and show the contents of the byte buffer
			System.out.println(Charset.defaultCharset().decode(buffer));
			

		} catch (IOException ex) {
			// TODO: Handle exception
		}
	}
}
