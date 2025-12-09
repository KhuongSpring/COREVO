# COREVO

🎉 Chào mừng bạn đến với kho mã nguồn của Corevo!

Đây là một dự án được thiết kế với mục tiêu gợi ý và xây dựng kế hoạch luyện tập cá nhân hóa.

## 📖 Mục lục

* 📍 [Giới thiệu](#-giới-thiệu)
* ✨ [Tính năng](#-tính-năng)
* 🏗️ [Tổng quan hệ thống](#️-tổng-quan-hệ-thống)
* 🤝 [Đóng góp cho dự án](#-đóng-góp-cho-dự-án)
* 📫 [Liên hệ](#-liên-hệ)

## 📍 Giới thiệu
Corevo là nền tảng hỗ trợ người dùng xây dựng và theo dõi kế hoạch luyện tập cho nhiều mục tiêu khác nhau. Hệ thống kết hợp workflow logic thông minh, cơ sở dữ liệu bài tập phong phú để tạo ra những kế hoạch luyện tập phù hợp nhất với từng người dùng.  

Mục tiêu chính của dự án:
- Xây dựng hệ thống giúp người dùng chọn đúng bài tập, đúng lộ trình, đúng mục tiêu.
- Tạo workflow hướng dẫn từng bước để người dùng không bị rối khi chọn lựa, chỉ hiển thị các lựa chọn phù hợp.
- Tối ưu trải nghiệm luyện tập thông qua bài tập phù hợp thể trạng, điều chỉnh reps/thời gian hợp lý, và theo dõi tiến độ.

## ✨ Tính năng

Dự án tập trung vào các chức năng chính sau:

* 🧭 Training Plan Builder (Workflow): Xây dựng kế hoạch luyện tập dựa trên lựa chọn step-by-step của người dùng.
* 🏋️‍♀️ Bài tập đa dạng và chuẩn hóa: Cung cấp thư viện các bài tập luyện đa dạng.
* ⚡ Điều chỉnh cường độ luyện tập: Hỗ trợ người dùng tự điều chỉnh cường độ luyện tập phù hợp.
* 📊 Theo dõi tiến độ: Liên tục theo dõi tiến độ luyện tập của người dùng.

## 🏗️ Tổng quan hệ thống
### 🖥️ Front-end

Dưới đây là tóm tắt các công nghệ, thư viện, và framework frontend chính đã được sử dụng để xây dựng dự án dashboard.

- [Flutter](https://flutter.dev/): UI đa nền tảng.
- [Dart](https://dart.dev/): Ngôn ngữ chính của ứng dụng.

### 🗄️ Back-end

Back-end của hệ thống được thiết kế theo kiến trúc MVC, với các công nghệ sử dụng như sau:

- [SpringBoot](https://spring.io/projects/spring-boot): Dựng API cho dự án.
- [Spring Data JPA (Hibernate)](https://spring.io/projects/spring-data-jpa): Công nghệ truy cập và làm việc với cơ sở dữ liệu.
- [Spring Security](https://spring.io/projects/spring-authorization-server): Công nghệ giúp triển khai bảo mật cho dự án.
- [JWT (Json Web Token)](https://www.jwt.io/): Token để hỗ trợ xác thực và phân quyền người dùng.
- [MySQL](https://www.mysql.com/): Cơ sở dữ liệu quan hệ.
- [Cloudinary](https://cloudinary.com/): Dịch vụ cloud để lưu trữ, quản lý và phân phối hình ảnh.
- [Docker](https://www.docker.com/): Containerize các service.
- [Docker Compose](https://docs.docker.com/compose): Quản lý các container.
- [Swagger](https://springdoc.org): Tự động tạo tài liệu và giao diện thử nghiệm API.

## 🤝 Đóng góp cho dự án

* [Bug Report ⚠️](https://github.com/KhuongSpring/COREVO/issues/new?title=🐛%20Bug%20Report:%20)
* [Request Feature 👩‍💻](https://github.com/KhuongSpring/COREVO/issues/new?title=✨%20Feature%20Request:%20)

Mọi đóng góp của các bạn đều được trân trọng, đừng ngần ngại gửi pull request cho dự án.

## 📫 Liên hệ

- Phạm Minh Khương: [pkhuong535@gmail.com](mailto:pkhuong535@gmail.com)
## 📜 License

This project is licensed under the terms of the [GPL V3 license](https://www.gnu.org/licenses/gpl-3.0.html).
