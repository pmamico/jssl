import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.*;

public class SSLPing {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.exit(1);
        }
        try {
            SSLSocketFactory sslsocketfactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
            SSLSocket sslsocket = (SSLSocket) sslsocketfactory.createSocket(args[0], Integer.parseInt(args[1]));

            SSLParameters sslparams = new SSLParameters();
            sslparams.setEndpointIdentificationAlgorithm("HTTPS");
            sslsocket.setSSLParameters(sslparams);

            InputStream in = sslsocket.getInputStream();
            OutputStream out = sslsocket.getOutputStream();

            out.write(1);

            while (in.available() > 0) {
                System.out.print(in.read());
            }
        } catch (Exception exception) {
            System.err.println(exception);
            System.exit(1);
        }
    }
}