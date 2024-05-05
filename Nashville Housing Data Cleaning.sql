/*

Cleaning Data in Sql queries

*/
-- below all the queries are same

Select *
from NashvilleHousing
--or
Select *
from [Portfolio Project]..NashvilleHousing
--or
Select *
from [Portfolio Project].dbo.NashvilleHousing


---------------------------------------------
--Standardize Date format

--below query is important

Select SaleDate
from NashvilleHousing

Select SaleDate,CONVERT(date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate)

Select SaleDateConverted,CONVERT(date,SaleDate)
from NashvilleHousing

-----------------------------------------------

--Populate Property Address data

Select PropertyAddress
from NashvilleHousing

Select PropertyAddress
from NashvilleHousing
where PropertyAddress is null

Select *
from NashvilleHousing
where PropertyAddress is null

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--IS NULL is saying if a.propertyaddress is null then populate it with b.propertyaddress
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a 
SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------

--Breaking out Address Into Individual Colums (Address,City, State)


--Property Address and owner address both will be breaked down.

--Delimiter used to seperate them is comma

Select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

--Using substring and charindex in this query

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address,CHARINDEX(',',PropertyAddress),PropertyAddress

from NashVilleHousing

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,CHARINDEX(',',PropertyAddress),PropertyAddress

from NashVilleHousing

--if +1 is removed comma will be seen in that before .
--Moreover we can not separate two values without separatig them into two colums.
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address,
PropertyAddress

from NashVilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select *
from NashvilleHousing

--Now working on OwnerAddress

Select *
from NashvilleHousing

Select OwnerAddress
from NashvilleHousing

--Not using substring in this OwnerAddress but using parse which takes string from backwards.

Select PARSENAME(OwnerAddress,1)
from NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 1),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
from NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select *
from NashvilleHousing

-------------------------------------

--Change Y and N to Yes and No in 'Solid as Vacant' field.

Select Distinct(SoldAsVacant)
from NashvilleHousing

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE WHEN SoldAsVacant='Y' then 'Yes'
     WHEN SoldAsVacant='N' then 'No'
	 ELSE SoldAsVacant
	 END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant='Y' then 'Yes'
     WHEN SoldAsVacant='N' then 'No'
	 ELSE SoldAsVacant
	 END

	 -------------------------------------------------------
  
  --Remove Duplicates(not understood)

  Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID) row_num
  from NashvilleHousing
  ORDER BY ParcelID
 -- where row_num >1(it will not work)

 WITH RowNumCTE AS(
 Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID) row_num
  from NashvilleHousing
  --ORDER BY ParcelID(order by clause does not work in CTE)
  )
  Select *
  from RowNumCTE
  

 WITH RowNumCTE AS(
 Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID) row_num
  from NashvilleHousing
  --ORDER BY ParcelID(order by clause does not work in CTE)
  )
  Select *
  from RowNumCTE
   where row_num > 1
   Order by PropertyAddress 


   WITH RowNumCTE AS(
 Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID) row_num
  from NashvilleHousing
  --ORDER BY ParcelID(order by clause does not work in CTE)
  )
  Delete
  from RowNumCTE
   where row_num > 1
  -- Order by PropertyAddress 


  Select *
  from NashvilleHousing

  --------------------------------------------------------------------

  --Delete Unused Colums


  Select *
  from NashvilleHousing

  ALTER TABLE NashvilleHousing
  DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

  ALTER TABLE NashvilleHousing
  DROP COLUMN SaleDate
