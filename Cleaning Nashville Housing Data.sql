select * 
from PortfolioProject.dbo.NashvilleHousing

select SaleDateConverted, CONVERT(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = Convert(date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = Convert(date, SaleDate)

--Populating PropertyAddress

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelId = b.ParcelID
and a.[UniqueId] <> b.[UniqueID]
where a.PropertyAddress is NULL

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelId = b.ParcelID
and a.[UniqueId] <> b.[UniqueID]
where a.PropertyAddress is NULL

--Breaking out Address into individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City 
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress NVARCHAR(255);

update NashvilleHousing
set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity NVARCHAR(255);

update NashvilleHousing
set PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR(255);

update NashvilleHousing
set OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity NVARCHAR(255);

update NashvilleHousing
set OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState NVARCHAR(255);

update NashvilleHousing
set OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from PortfolioProject.dbo.NashvilleHousing

-- Changing Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), Count(SoldAsVacant) 
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant, 
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant  = 'N' then 'No'
	 else SoldAsVacant
	 end as NewSoldAsVacant
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant  = 'N' then 'No'
	 else SoldAsVacant
	 end 

									-- Removing Duplicates

-- Finding Duplicates

WITH RowNumCTE AS (
select *,
ROW_NUMBER() OVER (
PARTITION by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
				UniqueID
				 ) row_num
from PortfolioProject.dbo.NashvilleHousing

)

select*
from RowNumCTE
where row_num >1
order by PropertyAddress

-- Deleteing Duplicate Code

WITH RowNumCTE AS (
select *,
ROW_NUMBER() OVER (
PARTITION by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
				UniqueID
				 ) row_num
from PortfolioProject.dbo.NashvilleHousing

)

DELETE 
from RowNumCTE
where row_num >1


--							Removing Unused Columns

select*
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, PropertyAddress, TaxDistrict

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate

--- Importing Data using OPENROWSET and BULK INSERT	






