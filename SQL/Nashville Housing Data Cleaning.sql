use [Portfolio Project];

select * from NashvilleHousing;

-- Convert column `SALEDATE` DATATYPE from DATETIME to DATE --

alter table NashvilleHousing
alter column saleDate date;

-- Filling column `PROPERTY ADDRESS` missing values --

update a
set
	a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from
	NashvilleHousing a join
	NashvilleHousing b on
	a.ParcelID = b.ParcelID AND
	a.UniqueID != b.UniqueID
where
	a.PropertyAddress is null;

-- Breaking out `PROPERTY ADDRESS` into Individual Columns (Address, City) --

alter table NashvilleHousing
add
	SplittedPropertyAddress nvarchar(255),
	PropertyCity nvarchar(255)


update NashvilleHousing
set 
	SplittedPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
	PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- Breaking out `OWNER ADDRESS` into Individual Columns (Address, City, State) --

alter table NashvilleHousing
add
	SplittedOwnerAddress nvarchar(255),
	OwnerCity nvarchar(255),
	OwnerState nvarchar(255)


update NashvilleHousing
set 
	SplittedOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Changed (Y as Yes) and (N as No) in column `SOLD AS VACANT` --

select
	SoldAsVacant,
	count(*) 'Count' from NashvilleHousing
group by SoldAsVacant
order by 'Count' desc -- Since Y and N are in minority we will change them


update NashvilleHousing
set SoldAsVacant =
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end

-- Filling column `OWNER ADDRESS` missing values --

select propertyAddress, len(propertyAddress), len(trim(propertyAddress))
from NashvilleHousing
where UniqueID in (56469 , 56470)

select PropertyAddress from NashvilleHousing
group by PropertyAddress

select PropertyAddress, SUBSTRING(OwnerAddress, 1, len(OwnerAddress) - 4) 'owner address' from NashvilleHousing
where ownerAddress is null
where propertyAddress = SUBSTRING(OwnerAddress, 1, len(OwnerAddress) - 4)

select * from NashvilleHousing