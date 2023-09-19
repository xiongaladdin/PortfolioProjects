--Cleaning Data in SQL Queries--------------------------------------------------------------------------------------------------------------------

Select *
From PorfolioProject1.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PorfolioProject1..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, Saledate)

--Highlight and select first then execute to perform query
ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, Saledate)


--Populating Property Address Data-------------------------------------------------------------------------------------------------------------

Select *
From PorfolioProject1.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

--Finds NULL PropertyAddress where ParcelID are the same and fills in the NULL with the PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject1.dbo.NashvilleHousing a
JOIN PorfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--When run below query is successful, run above query and results should show nothing
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject1.dbo.NashvilleHousing a
JOIN PorfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)-----------------------------------------------------------------------------

Select PropertyAddress
From PorfolioProject1.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

--Substring, Character Index
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, --(specifies what character you are looking for, -1 takes away ",")
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address --(splits Property City without the ",")
From PorfolioProject1.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Shows results of above queries
Select*
From PorfolioProject1..NashvilleHousing

--Owner Address Split using ParceName(easier method to split data)
Select OwnerAddress
From PorfolioProject1..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
From PorfolioProject1..NashvilleHousing

ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From PorfolioProject1..NashvilleHousing


--Change Y and N or 0 and 1 to Yes and No in "Sold as Vavant" field-------------------------------------------------------------------------------------
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PorfolioProject1..NashvilleHousing
Group by SoldAsVacant
Order by 2

--SoldAsVacant is by default bit Data type - converting to nvarchar Data type
ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant nvarchar(50);

Select SoldAsVacant,
CASE when SoldAsVacant = '1' then 'Yes'
	 when SoldAsVacant = '0' then 'No'
	 else SoldAsVacant
	 END
From PorfolioProject1..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = '1' then 'Yes'
	 when SoldAsVacant = '0' then 'No'
	 else SoldAsVacant
	 END


--Removing Duplicates with CTE-------------------------------------------------------------------------------------------------------------------------

With RowNumCTE as (
Select *,
	ROW_NUMBER() Over (
	PARTITION by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From PorfolioProject1..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Deletes Duplicates then run above query to verify results
With RowNumCTE as (
Select *,
	ROW_NUMBER() Over (
	PARTITION by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From PorfolioProject1..NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--Delete Unused Columns-------------------------------------------------------------------------------------------------------------

Select*
From PorfolioProject1..NashvilleHousing

ALTER TABLE PorfolioProject1..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PorfolioProject1..NashvilleHousing
DROP COLUMN SaleDate











































































































