package delays.cq;

import static delays.cq.Util.r;
import static delays.cq.Util.s;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.nio.file.Path;
import java.util.zip.GZIPInputStream;

public class Gzip {

   static Path gunzip(File from, File to) throws Exception {
      if (!to.exists()) {
         byte[] buffer = new byte[1024];
         FileInputStream fis = new FileInputStream(from);
         GZIPInputStream gzis = new GZIPInputStream(fis);
         FileOutputStream out = new FileOutputStream(to);

         int len;
         while ((len = gzis.read(buffer)) > 0)
            out.write(buffer, 0, len);

         gzis.close();
         out.close();

         System.out.printf("Finished gunzip to: %s%n", to);
      } else {
         System.out.printf("File already gunzipped to: %s%n", to);
      }

      return to.toPath();
   }

}