select *
From PortfolioProject.dbo.HousingData

-- Change Date Format (Remove Time)

select SaleDate, Convert(Date,SaleDate)
From PortfolioProject.dbo.HousingData

Alter Table HousingData
Add SaleDateCorrected Date;

Update HousingData
SET SaleDateCorrected = Convert(Date,SaleDate)

Select SaleDateCorrected
From PortfolioProject.dbo.HousingData

-- Property Address

Select *
From PortfolioProject.dbo.HousingData
----Where PropertyAddress is Null
Order by ParcelID

Select first.ParcelID, first.PropertyAddress, second.ParcelID, second.PropertyAddress, ISNULL(first.PropertyAddress,second.PropertyAddress)
From PortfolioProject.dbo.HousingData first
JOIN PortfolioProject.dbo.HousingData second
    on first.ParcelID = second.ParcelID
	AND first.[UniqueID] <> second.[UniqueID]
Where first.PropertyAddress is null

Update first
SET PropertyAddress = ISNULL(first.PropertyAddress,second.PropertyAddress)
From PortfolioProject.dbo.HousingData first
JOIN PortfolioProject.dbo.HousingData second
    on first.ParcelID = second.ParcelID
	AND first.[UniqueID] <> second.[UniqueID]
Where first.PropertyAddress is null

Select *
From PortfolioProject.dbo.HousingData
Where PropertyAddress is null

-- Splitting address into individual columns

Select PropertyAddress
From PortfolioProject.dbo.HousingData

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as CityName
From PortfolioProject.dbo.HousingData

Alter Table PortfolioProject.dbo.HousingData
Add PropertyAccurateAddress Nvarchar(255);

Update PortfolioProject.dbo.HousingData
SET PropertyAccurateAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table PortfolioProject.dbo.HousingData
Add PropertyAddressCity Nvarchar(255);

Update PortfolioProject.dbo.HousingData
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.HousingData

-- Owners Address

Select OwnerAddress
From PortfolioProject.dbo.HousingData

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.HousingData

Alter Table PortfolioProject.dbo.HousingData
Add OwnerAddressAccurate Nvarchar(255);

Update PortfolioProject.dbo.HousingData
SET OwnerAddressAccurate = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

Alter Table PortfolioProject.dbo.HousingData
Add OwnerAddressCity Nvarchar(255);

Update PortfolioProject.dbo.HousingData
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

Alter Table PortfolioProject.dbo.HousingData
Add OwnerAddressState Nvarchar(255);

Update PortfolioProject.dbo.HousingData
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProject.dbo.HousingData

---- Sold as Vacant Column Modification (Y/N)

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.HousingData
Group by SoldAsVacant
order by 2

 Select SoldAsVacant
 ,CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
 From PortfolioProject.dbo.HousingData

 Update PortfolioProject.dbo.HousingData
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--- Remove Duplicates

WITH RowNumCTE AS(
Select *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
					    UniqueID
						) row_num
	                 

From PortfolioProject.dbo.HousingData
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--- Delete Unused Columns

Select *
From PortfolioProject.dbo.HousingData

ALTER Table PortfolioProject.dbo.HousingData
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate












