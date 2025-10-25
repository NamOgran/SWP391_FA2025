USE [master]
GO
/****** Object:  Database [gio_swp391]    Script Date: 10/25/2025 6:12:49 PM ******/
CREATE DATABASE [gio_swp391]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'gio_swp391', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\gio_swp391.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'gio_swp391_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\gio_swp391_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [gio_swp391] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [gio_swp391].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [gio_swp391] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [gio_swp391] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [gio_swp391] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [gio_swp391] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [gio_swp391] SET ARITHABORT OFF 
GO
ALTER DATABASE [gio_swp391] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [gio_swp391] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [gio_swp391] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [gio_swp391] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [gio_swp391] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [gio_swp391] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [gio_swp391] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [gio_swp391] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [gio_swp391] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [gio_swp391] SET  ENABLE_BROKER 
GO
ALTER DATABASE [gio_swp391] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [gio_swp391] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [gio_swp391] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [gio_swp391] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [gio_swp391] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [gio_swp391] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [gio_swp391] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [gio_swp391] SET RECOVERY FULL 
GO
ALTER DATABASE [gio_swp391] SET  MULTI_USER 
GO
ALTER DATABASE [gio_swp391] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [gio_swp391] SET DB_CHAINING OFF 
GO
ALTER DATABASE [gio_swp391] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [gio_swp391] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [gio_swp391] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [gio_swp391] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'gio_swp391', N'ON'
GO
ALTER DATABASE [gio_swp391] SET QUERY_STORE = ON
GO
ALTER DATABASE [gio_swp391] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [gio_swp391]
GO
/****** Object:  Table [dbo].[cart]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[quantity] [int] NULL,
	[price] [int] NULL,
	[customer_id] [int] NULL,
	[product_id] [int] NULL,
	[size_name] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[category]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[category](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[type] [varchar](50) NULL,
	[gender] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customer]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[email] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[address] [varchar](255) NULL,
	[phoneNumber] [varchar](12) NULL,
	[fullName] [varchar](100) NULL,
	[google_id] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[feedback]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feedback](
	[feedback_id] [int] IDENTITY(1,1) NOT NULL,
	[content] [varchar](255) NULL,
	[rate_point] [int] NULL,
	[customer_id] [int] NULL,
	[product_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[feedback_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[import]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[import](
	[import_id] [int] IDENTITY(1,1) NOT NULL,
	[importDate] [date] NULL,
	[staff_id] [int] NULL,
	[status] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[import_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[importDetails]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[importDetails](
	[import_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[import_id] [int] NULL,
	[product_id] [int] NULL,
	[size_name] [varchar](5) NULL,
	[quantity] [int] NULL,
 CONSTRAINT [PK__importDe__6C144AB29687A352] PRIMARY KEY CLUSTERED 
(
	[import_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_detail]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_detail](
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[size_name] [varchar](5) NOT NULL,
	[quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[product_id] ASC,
	[size_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[address] [varchar](255) NULL,
	[date] [date] NULL,
	[status] [varchar](10) NULL,
	[phone_number] [varchar](12) NULL,
	[customer_id] [int] NULL,
	[staff_id] [int] NULL,
	[total] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NULL,
	[quantity] [int] NULL,
	[description] [nvarchar](255) NULL,
	[pic_url] [varchar](255) NULL,
	[price] [int] NULL,
	[category_id] [int] NULL,
	[promo_id] [int] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[promo]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promo](
	[promo_id] [int] IDENTITY(1,1) NOT NULL,
	[promo_percent] [int] NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[promo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[size_detail]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[size_detail](
	[product_id] [int] NOT NULL,
	[size_name] [varchar](5) NOT NULL,
	[quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[size_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[staff]    Script Date: 10/25/2025 6:12:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staff](
	[staff_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[email] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[address] [varchar](255) NULL,
	[phoneNumber] [varchar](12) NULL,
	[fullName] [varchar](100) NULL,
	[role] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[product] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[staff] ADD  DEFAULT ('staff') FOR [role]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([product_id], [size_name])
REFERENCES [dbo].[size_detail] ([product_id], [size_name])
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Customer] FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer] ([customer_id])
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [FK_Cart_Customer]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer] ([customer_id])
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
ALTER TABLE [dbo].[import]  WITH CHECK ADD FOREIGN KEY([staff_id])
REFERENCES [dbo].[staff] ([staff_id])
GO
ALTER TABLE [dbo].[importDetails]  WITH CHECK ADD  CONSTRAINT [FK_importDetails_import] FOREIGN KEY([import_id])
REFERENCES [dbo].[import] ([import_id])
GO
ALTER TABLE [dbo].[importDetails] CHECK CONSTRAINT [FK_importDetails_import]
GO
ALTER TABLE [dbo].[importDetails]  WITH CHECK ADD  CONSTRAINT [FK_importDetails_size_detail] FOREIGN KEY([product_id], [size_name])
REFERENCES [dbo].[size_detail] ([product_id], [size_name])
GO
ALTER TABLE [dbo].[importDetails] CHECK CONSTRAINT [FK_importDetails_size_detail]
GO
ALTER TABLE [dbo].[order_detail]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
ALTER TABLE [dbo].[order_detail]  WITH CHECK ADD FOREIGN KEY([product_id], [size_name])
REFERENCES [dbo].[size_detail] ([product_id], [size_name])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer] ([customer_id])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([staff_id])
REFERENCES [dbo].[staff] ([staff_id])
GO
ALTER TABLE [dbo].[product]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[category] ([category_id])
GO
ALTER TABLE [dbo].[product]  WITH CHECK ADD FOREIGN KEY([promo_id])
REFERENCES [dbo].[promo] ([promo_id])
GO
ALTER TABLE [dbo].[size_detail]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
USE [master]
GO
ALTER DATABASE [gio_swp391] SET  READ_WRITE 
GO
