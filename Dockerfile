# Sử dụng JDK 17 làm base image
FROM eclipse-temurin:17-jdk as builder

# Đặt thư mục làm thư mục làm việc
WORKDIR /app

# Copy toàn bộ mã nguồn vào container
COPY . .

# Biên dịch ứng dụng với Maven (bỏ qua test để build nhanh hơn)
RUN ./mvnw clean package -DskipTests

# Giai đoạn chạy ứng dụng (dùng JDK runtime để giảm dung lượng image)
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy file JAR từ giai đoạn build trước đó
COPY --from=builder /app/target/*.jar app.jar

# Expose cổng 8080 để truy cập ứng dụng
EXPOSE 8080

# Chạy ứng dụng khi container khởi động
CMD ["java", "-jar", "app.jar"]
