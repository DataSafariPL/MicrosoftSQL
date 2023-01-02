				Cleaning Data in SQL Queries
-------------------------------------------------------------
Select *
From PortfolioProject.dbo.House

-------------------------------------------------------------Standardize Date Format

ALTER TABLE PortfolioProject.dbo.House
Add SaleDateConverted Date;

Update House
SET SaleDateConverted = CONVERT(Date,SaleDate)


-------------------------------------------------------------Populate Property Address data

Select *
From PortfolioProject.dbo.House
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.House a
JOIN PortfolioProject.dbo.House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.House a
JOIN PortfolioProject.dbo.House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-------------------------------------------------------------Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.House
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.House


ALTER TABLE PortfolioProject.dbo.House
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.House
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject.dbo.House
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.House
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.House

Select OwnerAddress
From PortfolioProject.dbo.House

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.House


ALTER TABLE PortfolioProject.dbo.House
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.House
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.House
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.House
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject.dbo.House
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.House
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.House


-------------------------------------------------------------Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.House
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.House


Update PortfolioProject.dbo.House
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-------------------------------------------------------------Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.House
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.House


-------------------------------------------------------------Delete Unused Columns



Select *
From PortfolioProject.dbo.House


ALTER TABLE PortfolioProject.dbo.House
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
