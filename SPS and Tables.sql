USE [Posdb]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[ImageURL] [nvarchar](255) NULL,
	[CostPrice] [decimal](10, 2) NULL,
	[RetailPrice] [decimal](10, 2) NULL,
	[CreationDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaleDetails]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaleDetails](
	[SaleDetailId] [int] IDENTITY(1,1) NOT NULL,
	[SaleId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[RetailPrice] [decimal](10, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[SaleDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sales]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales](
	[SaleId] [int] IDENTITY(1,1) NOT NULL,
	[Total] [decimal](10, 2) NOT NULL,
	[SaleDate] [datetime] NOT NULL,
	[SalespersonId] [int] NULL,
	[Comments] [nvarchar](500) NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salesperson]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salesperson](
	[SalespersonId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[EnteredDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SalespersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreationDate]
GO
ALTER TABLE [dbo].[Salesperson] ADD  DEFAULT (getdate()) FOR [EnteredDate]
GO
ALTER TABLE [dbo].[SaleDetails]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[SaleDetails]  WITH CHECK ADD FOREIGN KEY([SaleId])
REFERENCES [dbo].[Sales] ([SaleId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Sales]  WITH CHECK ADD FOREIGN KEY([SalespersonId])
REFERENCES [dbo].[Salesperson] ([SalespersonId])
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateProduct]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_CreateProduct
CREATE PROCEDURE [dbo].[sp_CreateProduct]
    @Name NVARCHAR(100),
    @Code NVARCHAR(50) = NULL,
    @ImageURL NVARCHAR(255) = NULL,
    @CostPrice DECIMAL(10, 2) = NULL,
    @RetailPrice DECIMAL(10, 2) = NULL
AS
BEGIN
    DECLARE @NewProductId INT;
    
    INSERT INTO Products (Name, Code, ImageURL, CostPrice, RetailPrice, CreationDate, UpdatedDate)
    VALUES (@Name, @Code, @ImageURL, @CostPrice, @RetailPrice, GETDATE(), NULL);
    
    SET @NewProductId = SCOPE_IDENTITY();
    
    SELECT ProductId, Name, Code, ImageURL, CostPrice, RetailPrice, CreationDate, UpdatedDate
    FROM Products
    WHERE ProductId = @NewProductId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateSale]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_CreateSale
CREATE PROCEDURE [dbo].[sp_CreateSale]
    @Total DECIMAL(10, 2),
    @SaleDate DATETIME,
    @SalespersonId INT = NULL,
    @Comments NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @NewSaleId INT;
    
    INSERT INTO Sales (Total, SaleDate, SalespersonId, Comments, UpdatedDate)
    VALUES (@Total, @SaleDate, @SalespersonId, @Comments, NULL);
    
    SET @NewSaleId = SCOPE_IDENTITY();
    
    SELECT SaleId, Total, SaleDate, SalespersonId, Comments, UpdatedDate
    FROM Sales
    WHERE SaleId = @NewSaleId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateSaleDetail]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_CreateSaleDetail
CREATE PROCEDURE [dbo].[sp_CreateSaleDetail]
    @SaleId INT,
    @ProductId INT,
    @RetailPrice DECIMAL(10, 2),
    @Quantity INT,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    DECLARE @NewSaleDetailId INT;
    
    INSERT INTO SaleDetails (SaleId, ProductId, RetailPrice, Quantity, Discount)
    VALUES (@SaleId, @ProductId, @RetailPrice, @Quantity, @Discount);
    
    SET @NewSaleDetailId = SCOPE_IDENTITY();
    
    SELECT SaleDetailId, SaleId, ProductId, RetailPrice, Quantity, Discount
    FROM SaleDetails
    WHERE SaleDetailId = @NewSaleDetailId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteProduct]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_DeleteProduct
CREATE PROCEDURE [dbo].[sp_DeleteProduct]
    @ProductId INT
AS
BEGIN
    DELETE FROM Products
    WHERE ProductId = @ProductId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteSale]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_DeleteSale
CREATE PROCEDURE [dbo].[sp_DeleteSale]
    @SaleId INT
AS
BEGIN
    DELETE FROM Sales
    WHERE SaleId = @SaleId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteSaleDetail]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_DeleteSaleDetail
CREATE PROCEDURE [dbo].[sp_DeleteSaleDetail]
    @SaleDetailId INT
AS
BEGIN
    DELETE FROM SaleDetails
    WHERE SaleDetailId = @SaleDetailId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteSaleDetailsBySaleId]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_DeleteSaleDetailsBySaleId
CREATE PROCEDURE [dbo].[sp_DeleteSaleDetailsBySaleId]
    @SaleId INT
AS
BEGIN
    DELETE FROM SaleDetails
    WHERE SaleId = @SaleId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteSalesperson]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_DeleteSalesperson
CREATE PROCEDURE [dbo].[sp_DeleteSalesperson]
    @SalespersonId INT
AS
BEGIN
    DELETE FROM Salesperson
    WHERE SalespersonId = @SalespersonId;
    
    RETURN @@ROWCOUNT;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetActiveSalespersons]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetActiveSalespersons
CREATE PROCEDURE [dbo].[sp_GetActiveSalespersons]
AS
BEGIN
    SELECT SalespersonId, Name, Code, EnteredDate, UpdatedDate
    FROM Salesperson;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllProducts]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- STORED PROCEDURES FOR PRODUCTS
-- =============================================

-- sp_GetAllProducts
CREATE PROCEDURE [dbo].[sp_GetAllProducts]
AS
BEGIN
    SELECT ProductId, Name, Code, ImageURL, CostPrice, RetailPrice, CreationDate, UpdatedDate
    FROM Products;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSaleDetails]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- STORED PROCEDURES FOR SALE DETAILS
-- =============================================

-- sp_GetAllSaleDetails
CREATE PROCEDURE [dbo].[sp_GetAllSaleDetails]
AS
BEGIN
    SELECT SaleDetailId, SaleId, ProductId, RetailPrice, Quantity, Discount
    FROM SaleDetails;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSales]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- STORED PROCEDURES FOR SALES
-- =============================================

-- sp_GetAllSales
CREATE PROCEDURE [dbo].[sp_GetAllSales]
AS
BEGIN
    SELECT SaleId, Total, SaleDate, SalespersonId, Comments, UpdatedDate
    FROM Sales;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSalespersons]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- STORED PROCEDURES FOR SALESPERSON
-- =============================================

-- sp_GetAllSalespersons
CREATE PROCEDURE [dbo].[sp_GetAllSalespersons]
AS
BEGIN
    SELECT SalespersonId, Name, Code, EnteredDate, UpdatedDate
    FROM Salesperson;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductById]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetProductById
CREATE PROCEDURE [dbo].[sp_GetProductById]
    @ProductId INT
AS
BEGIN
    SELECT ProductId, Name, Code, ImageURL, CostPrice, RetailPrice, CreationDate, UpdatedDate
    FROM Products
    WHERE ProductId = @ProductId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSaleById]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSaleById
CREATE PROCEDURE [dbo].[sp_GetSaleById]
    @SaleId INT
AS
BEGIN
    SELECT SaleId, Total, SaleDate, SalespersonId, Comments, UpdatedDate
    FROM Sales
    WHERE SaleId = @SaleId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSaleDetailById]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSaleDetailById
CREATE PROCEDURE [dbo].[sp_GetSaleDetailById]
    @SaleDetailId INT
AS
BEGIN
    SELECT SaleDetailId, SaleId, ProductId, RetailPrice, Quantity, Discount
    FROM SaleDetails
    WHERE SaleDetailId = @SaleDetailId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSaleDetailsBySaleId]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSaleDetailsBySaleId
CREATE PROCEDURE [dbo].[sp_GetSaleDetailsBySaleId]
    @SaleId INT
AS
BEGIN
    SELECT SaleDetailId, SaleId, ProductId, RetailPrice, Quantity, Discount
    FROM SaleDetails
    WHERE SaleId = @SaleId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesByDateRange]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSalesByDateRange
CREATE PROCEDURE [dbo].[sp_GetSalesByDateRange]
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT SaleId, Total, SaleDate, SalespersonId, Comments, UpdatedDate
    FROM Sales
    WHERE SaleDate BETWEEN @StartDate AND @EndDate;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesBySalesperson]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSalesBySalesperson
CREATE PROCEDURE [dbo].[sp_GetSalesBySalesperson]
    @SalespersonId INT
AS
BEGIN
    SELECT SaleId, Total, SaleDate, SalespersonId, Comments, UpdatedDate
    FROM Sales
    WHERE SalespersonId = @SalespersonId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalespersonByCode]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSalespersonByCode
CREATE PROCEDURE [dbo].[sp_GetSalespersonByCode]
    @Code NVARCHAR(50)
AS
BEGIN
    SELECT SalespersonId, Name, Code, EnteredDate, UpdatedDate
    FROM Salesperson
    WHERE Code = @Code;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalespersonById]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSalespersonById
CREATE PROCEDURE [dbo].[sp_GetSalespersonById]
    @SalespersonId INT
AS
BEGIN
    SELECT SalespersonId, Name, Code, EnteredDate, UpdatedDate
    FROM Salesperson
    WHERE SalespersonId = @SalespersonId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSaleTotal]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_GetSaleTotal
CREATE PROCEDURE [dbo].[sp_GetSaleTotal]
    @SaleId INT
AS
BEGIN
    SELECT ISNULL(SUM((RetailPrice * Quantity) - ((RetailPrice * Quantity) * ISNULL(Discount, 0) / 100)), 0) AS Total
    FROM SaleDetails
    WHERE SaleId = @SaleId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertSalesperson]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_InsertSalesperson
CREATE PROCEDURE [dbo].[sp_InsertSalesperson]
    @Name NVARCHAR(100),
    @Code NVARCHAR(50),
    @EnteredDate DATETIME = NULL
AS
BEGIN
    INSERT INTO Salesperson (Name, Code, EnteredDate, UpdatedDate)
    VALUES (@Name, @Code, ISNULL(@EnteredDate, GETDATE()), NULL);
    
    SELECT SCOPE_IDENTITY() AS NewSalespersonId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ProductExists]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_ProductExists
CREATE PROCEDURE [dbo].[sp_ProductExists]
    @ProductId INT
AS
BEGIN
    SELECT COUNT(*) AS ProductCount
    FROM Products
    WHERE ProductId = @ProductId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaleDetailExists]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_SaleDetailExists
CREATE PROCEDURE [dbo].[sp_SaleDetailExists]
    @SaleDetailId INT
AS
BEGIN
    SELECT COUNT(*) AS SaleDetailCount
    FROM SaleDetails
    WHERE SaleDetailId = @SaleDetailId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaleExists]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_SaleExists
CREATE PROCEDURE [dbo].[sp_SaleExists]
    @SaleId INT
AS
BEGIN
    SELECT COUNT(*) AS SaleCount
    FROM Sales
    WHERE SaleId = @SaleId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SalespersonExists]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_SalespersonExists
CREATE PROCEDURE [dbo].[sp_SalespersonExists]
    @SalespersonId INT
AS
BEGIN
    SELECT COUNT(*) AS SalespersonCount
    FROM Salesperson
    WHERE SalespersonId = @SalespersonId;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProduct]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_UpdateProduct
CREATE PROCEDURE [dbo].[sp_UpdateProduct]
    @ProductId INT,
    @Name NVARCHAR(100),
    @Code NVARCHAR(50) = NULL,
    @ImageURL NVARCHAR(255) = NULL,
    @CostPrice DECIMAL(10, 2) = NULL,
    @RetailPrice DECIMAL(10, 2) = NULL
AS
BEGIN
    UPDATE Products
    SET Name = @Name,
        Code = @Code,
        ImageURL = @ImageURL,
        CostPrice = @CostPrice,
        RetailPrice = @RetailPrice,
        UpdatedDate = GETDATE()
    WHERE ProductId = @ProductId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSale]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_UpdateSale
CREATE PROCEDURE [dbo].[sp_UpdateSale]
    @SaleId INT,
    @Total DECIMAL(10, 2),
    @SaleDate DATETIME,
    @SalespersonId INT = NULL,
    @Comments NVARCHAR(500) = NULL
AS
BEGIN
    UPDATE Sales
    SET Total = @Total,
        SaleDate = @SaleDate,
        SalespersonId = @SalespersonId,
        Comments = @Comments,
        UpdatedDate = GETDATE()
    WHERE SaleId = @SaleId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSaleDetail]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_UpdateSaleDetail
CREATE PROCEDURE [dbo].[sp_UpdateSaleDetail]
    @SaleDetailId INT,
    @SaleId INT,
    @ProductId INT,
    @RetailPrice DECIMAL(10, 2),
    @Quantity INT,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    UPDATE SaleDetails
    SET SaleId = @SaleId,
        ProductId = @ProductId,
        RetailPrice = @RetailPrice,
        Quantity = @Quantity,
        Discount = @Discount
    WHERE SaleDetailId = @SaleDetailId;
    
    SELECT CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS Success;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSalesperson]    Script Date: 10/24/2025 3:38:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sp_UpdateSalesperson
CREATE PROCEDURE [dbo].[sp_UpdateSalesperson]
    @SalespersonId INT,
    @Name NVARCHAR(100),
    @Code NVARCHAR(50),
    @EnteredDate DATETIME = NULL
AS
BEGIN
    UPDATE Salesperson
    SET Name = @Name,
        Code = @Code,
        EnteredDate = @EnteredDate,
        UpdatedDate = GETDATE()
    WHERE SalespersonId = @SalespersonId;
    
    RETURN @@ROWCOUNT;
END
GO

//This is for Pagination:

ALTER PROCEDURE sp_GetAllProducts
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        ProductId,
        Name,
        Code,
        ImageURL,
        CostPrice,
        RetailPrice,
        CreationDate,
        UpdatedDate,
        (SELECT COUNT(*) FROM Products) AS TotalRecords
    FROM Products
    ORDER BY ProductId
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END

ALTER PROCEDURE sp_GetAllSalespersons
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        SalespersonId,
        Name,
        Code,
        EnteredDate,
        UpdatedDate,
        (SELECT COUNT(*) FROM Salesperson) AS TotalRecords
    FROM Salesperson
    ORDER BY SalespersonId
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END


ALTER PROCEDURE sp_GetAllSaleDetails
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        SaleDetailId,
        SaleId,
        ProductId,
        RetailPrice,
        Quantity,
        Discount,
        (SELECT COUNT(*) FROM SaleDetails) AS TotalRecords
    FROM SaleDetails
    ORDER BY SaleDetailId
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END



//New table and Sps for Sales one create Date
	
	
USE [Posdb]
GO
-- Add CreatedDate column with automatic default
ALTER TABLE [dbo].[Sales] 
ADD [CreatedDate] [datetime] NOT NULL 
CONSTRAINT DF_Sales_CreatedDate DEFAULT (GETDATE());
GO
-- Update existing records to use their SaleDate as CreatedDate
UPDATE [dbo].[Sales] 
SET CreatedDate = SaleDate;
GO

USE [Posdb]
GO

-- ✅ Update sp_GetAllSales
ALTER PROCEDURE [dbo].[sp_GetAllSales]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SaleId,
        Total,
        SaleDate,
        SalespersonId,
        Comments,
        CreatedDate,    -- ✅ ADDED
        UpdatedDate
    FROM Sales
    ORDER BY SaleId DESC;
END
GO

-- ✅ Update sp_GetSaleById
ALTER PROCEDURE [dbo].[sp_GetSaleById]
    @SaleId INT
AS
BEGIN
    SELECT 
        SaleId, 
        Total, 
        SaleDate, 
        SalespersonId, 
        Comments, 
        CreatedDate,    -- ✅ ADDED
        UpdatedDate
    FROM Sales
    WHERE SaleId = @SaleId;
END
GO

-- ✅ Update sp_CreateSale (CreatedDate automatically set by DEFAULT constraint)
ALTER PROCEDURE [dbo].[sp_CreateSale]
    @Total DECIMAL(10, 2),
    @SaleDate DATETIME,
    @SalespersonId INT = NULL,
    @Comments NVARCHAR(500) = NULL
AS
BEGIN
    DECLARE @NewSaleId INT;
    
    -- CreatedDate will automatically be set to GETDATE() by the DEFAULT constraint
    INSERT INTO Sales (Total, SaleDate, SalespersonId, Comments, UpdatedDate)
    VALUES (@Total, @SaleDate, @SalespersonId, @Comments, NULL);
    
    SET @NewSaleId = SCOPE_IDENTITY();
    
    SELECT 
        SaleId, 
        Total, 
        SaleDate, 
        SalespersonId, 
        Comments, 
        CreatedDate,    -- ✅ ADDED
        UpdatedDate
    FROM Sales
    WHERE SaleId = @NewSaleId;
END
GO

-- ✅ Update sp_GetSalesByDateRange
ALTER PROCEDURE [dbo].[sp_GetSalesByDateRange]
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT 
        SaleId, 
        Total, 
        SaleDate, 
        SalespersonId, 
        Comments, 
        CreatedDate,    -- ✅ ADDED
        UpdatedDate
    FROM Sales
    WHERE SaleDate BETWEEN @StartDate AND @EndDate
    ORDER BY SaleDate DESC;
END
GO

-- ✅ Update sp_GetSalesBySalesperson
ALTER PROCEDURE [dbo].[sp_GetSalesBySalesperson]
    @SalespersonId INT
AS
BEGIN
    SELECT 
        SaleId, 
        Total, 
        SaleDate, 
        SalespersonId, 
        Comments, 
        CreatedDate,    -- ✅ ADDED
        UpdatedDate
    FROM Sales
    WHERE SalespersonId = @SalespersonId
    ORDER BY SaleDate DESC;
END
GO


//order 
USE [Posdb]
GO

-- ✅ Fix sp_GetAllProducts - Show newest first
ALTER PROCEDURE [dbo].[sp_GetAllProducts]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        ProductId,
        Name,
        Code,
        ImageURL,
        CostPrice,
        RetailPrice,
        CreationDate,
        UpdatedDate,
        (SELECT COUNT(*) FROM Products) AS TotalRecords
    FROM Products
    ORDER BY ProductId DESC  -- ✅ CHANGED: DESC instead of ASC (newest first!)
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- ✅ Fix sp_GetAllSalespersons - Show newest first
ALTER PROCEDURE [dbo].[sp_GetAllSalespersons]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        SalespersonId,
        Name,
        Code,
        EnteredDate,
        UpdatedDate,
        (SELECT COUNT(*) FROM Salesperson) AS TotalRecords
    FROM Salesperson
    ORDER BY SalespersonId DESC  -- ✅ CHANGED: DESC instead of ASC (newest first!)
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO



//For foreign key consistents 


//ForDetele Sale 
-- ========================================
-- FIX: Remove CASCADE to enforce foreign key protection
-- ========================================
USE [Posdb]
GO

-- ========================================
-- STEP 1: Find and Drop the CASCADE foreign key
-- ========================================
DECLARE @ForeignKeyName NVARCHAR(256);
DECLARE @DropSQL NVARCHAR(MAX);

-- Find the foreign key name for SaleDetails -> Sales
SELECT @ForeignKeyName = fk.name
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc 
    ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'SaleDetails'
    AND OBJECT_NAME(fk.referenced_object_id) = 'Sales'
    AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) = 'SaleId';

-- Drop the foreign key if it exists
IF @ForeignKeyName IS NOT NULL
BEGIN
    SET @DropSQL = 'ALTER TABLE [dbo].[SaleDetails] DROP CONSTRAINT [' + @ForeignKeyName + '];';
    EXEC sp_executesql @DropSQL;
    PRINT '✅ Dropped CASCADE foreign key: ' + @ForeignKeyName;
END
ELSE
BEGIN
    PRINT '⚠️ Foreign key not found!';
END

GO

-- ========================================
-- STEP 2: Recreate foreign key WITHOUT CASCADE
-- ========================================
ALTER TABLE [dbo].[SaleDetails]
ADD CONSTRAINT FK_SaleDetails_Sales
FOREIGN KEY([SaleId])
REFERENCES [dbo].[Sales]([SaleId]);
-- ✅ NO CASCADE - Foreign key will now PREVENT deletion!

PRINT '✅ Foreign key recreated WITHOUT CASCADE';
PRINT '';
PRINT '========================================';
PRINT 'FIX COMPLETED SUCCESSFULLY!';
PRINT '========================================';
PRINT '';
PRINT '✅ Now your sp_DeleteSale stored procedure will work correctly:';
PRINT '   - If Sale has SaleDetails → Returns error message';
PRINT '   - If Sale has no SaleDetails → Deletes successfully';
PRINT '';
PRINT '✅ Your backend error handling will now work as expected!';
GO


//Now for DeleteSaleDetails

USE [Posdb]
GO

-- ========================================
-- FIX: sp_DeleteSaleDetail - PREVENT deletion if part of a Sale
-- ========================================
ALTER PROCEDURE [dbo].[sp_DeleteSaleDetail]
    @SaleDetailId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Check if sale detail exists
        IF NOT EXISTS (SELECT 1 FROM SaleDetails WHERE SaleDetailId = @SaleDetailId)
        BEGIN
            SELECT 0 AS Success, 'Sale detail not found.' AS Message;
            RETURN;
        END
        
        -- ✅ NEW CHECK: Prevent deletion if this SaleDetail belongs to a Sale
        DECLARE @SaleId INT;
        SELECT @SaleId = SaleId FROM SaleDetails WHERE SaleDetailId = @SaleDetailId;
        
        IF @SaleId IS NOT NULL
        BEGIN
            SELECT 0 AS Success, 
                   'Cannot delete sale detail. This item is part of Sale ID ' + CAST(@SaleId AS NVARCHAR(10)) + 
                   '. Please delete the entire sale instead, or remove this item from the sale first.' AS Message;
            RETURN;
        END
        
        -- If we reach here, it means SaleId is NULL (orphaned record - shouldn't happen)
        -- Only then allow deletion
        DELETE FROM SaleDetails
        WHERE SaleDetailId = @SaleDetailId;
        
        IF @@ROWCOUNT > 0
            SELECT 1 AS Success, 'Sale detail deleted successfully.' AS Message;
        ELSE
            SELECT 0 AS Success, 'Failed to delete sale detail.' AS Message;
            
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            SELECT 0 AS Success, 'Cannot delete sale detail. This record is referenced by other records in the database.' AS Message;
        ELSE
            SELECT 0 AS Success, 'Database error: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END
GO

-- ========================================
-- FIX: sp_DeleteSaleDetailsBySaleId - Also update this one
-- ========================================
ALTER PROCEDURE [dbo].[sp_DeleteSaleDetailsBySaleId]
    @SaleId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- ✅ Check if Sale exists
        IF NOT EXISTS (SELECT 1 FROM Sales WHERE SaleId = @SaleId)
        BEGIN
            SELECT 0 AS Success, 'Sale not found.' AS Message;
            RETURN;
        END
        
        -- ✅ Prevent deletion - require deleting the Sale first
        IF EXISTS (SELECT 1 FROM SaleDetails WHERE SaleId = @SaleId)
        BEGIN
            SELECT 0 AS Success, 
                   'Cannot delete sale details. These items are part of an active sale. Please delete the entire sale (Sale ID ' + 
                   CAST(@SaleId AS NVARCHAR(10)) + ') to remove all associated items.' AS Message;
            RETURN;
        END
        
        -- If no details exist, return success
        SELECT 1 AS Success, 'No sale details found for this sale.' AS Message;
            
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547
            SELECT 0 AS Success, 'Cannot delete sale details. They are referenced by other records.' AS Message;
        ELSE
            SELECT 0 AS Success, 'Database error: ' + ERROR_MESSAGE() AS Message;
    END CATCH
END
GO

PRINT '========================================';
PRINT '✅ FIXED: Both stored procedures updated!';
PRINT '========================================';
PRINT '';
PRINT '✅ sp_DeleteSaleDetail now PREVENTS deletion';
PRINT '✅ sp_DeleteSaleDetailsBySaleId now PREVENTS deletion';
PRINT '';
PRINT 'Now BOTH Sale and SaleDetail cannot be deleted!';
PRINT 'Users must delete the entire Sale to remove items.';
PRINT '========================================';




//new one for DeleteSalePerson SP 

ALTER PROCEDURE [dbo].[sp_DeleteSalesperson]
    @SalespersonId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Salesperson exists
    IF NOT EXISTS (SELECT 1 FROM Salesperson WHERE SalespersonId = @SalespersonId)
    BEGIN
        RETURN -1; -- not found
    END

    -- Check for foreign key dependencies (Sales or SaleDetails etc.)
    IF EXISTS (SELECT 1 FROM Sales WHERE SalespersonId = @SalespersonId)
    BEGIN
        RETURN -2; -- has foreign key reference, cannot delete
    END

    -- If safe, delete the record
    DELETE FROM Salesperson WHERE SalespersonId = @SalespersonId;

    RETURN @@ROWCOUNT; -- 1 means deleted successfully
END


