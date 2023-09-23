--DATA CLEANING PROJECT USING SQL

SELECT *
FROM portfolio_project..[Nashville housing]

--Standarizing sale date

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM portfolio_project..[Nashville housing]

ALTER TABLE [Nashville housing]
Add SaleDateConverted Date;

Update [Nashville housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM portfolio_project..[Nashville housing]

--Populate Property Address data

SELECT *
FROM portfolio_project..[Nashville housing]
--WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolio_project..[Nashville housing] a
JOIN portfolio_project..[Nashville housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolio_project..[Nashville housing] a
JOIN portfolio_project..[Nashville housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking out address into individual columns (address, city, state)
SELECT Propertyaddress
FROM portfolio_project..[Nashville housing]

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM portfolio_project..[Nashville housing]

ALTER TABLE portfolio_project..[Nashville housing]
Add PropertySplitAddress Nvarchar(255);

Update portfolio_project..[Nashville housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE portfolio_project..[Nashville housing]
Add PropertySplitCity Nvarchar(255);

Update portfolio_project..[Nashville housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select *
From portfolio_project..[Nashville housing]

Select OwnerAddress
From portfolio_project..[Nashville housing]

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From portfolio_project..[Nashville housing]

ALTER TABLE portfolio_project..[Nashville housing]
Add OwnersplitAddress Nvarchar(255);

Update portfolio_project..[Nashville housing]
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE portfolio_project..[Nashville housing]
Add OwnerSplitCity Nvarchar(255);

Update portfolio_project..[Nashville housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE portfolio_project..[Nashville housing]
Add OwnerSplitstate Nvarchar(255);

Update portfolio_project..[Nashville housing]
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From portfolio_project..[Nashville housing]


--Change "sold as Vacant" field Y and N TO yes and no

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolio_project..[Nashville housing]
Group by SoldAsVacant
Order by SoldAsVacant


SELECT SoldAsVacant
,CASE When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  End
From portfolio_project..[Nashville housing]


Update portfolio_project..[Nashville housing]
SET SoldAsVacant=CASE When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  End


--REMOVE DUPLICATES
WITH RowNumCTE AS(
SELECT *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
	   PropertyAddress,
	   SalePrice,
	   SaleDate,
	   LegalReference
	   ORDER BY
	      UniqueID
		  ) row_num

FROM portfolio_project..[Nashville housing]
--Order by ParcelID
)
DELETE
FROM RowNumCTE
Where row_num>1
ORDER BY PropertyAddress

SELECT *
FROM portfolio_project..[Nashville housing]

--Delete Unused Columns

SELECT *
FROM portfolio_project..[Nashville housing]

ALTER TABLE portfolio_project..[Nashville housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portfolio_project..[Nashville housing]
DROP COLUMN SaleDate