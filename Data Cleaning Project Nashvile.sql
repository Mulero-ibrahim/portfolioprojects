select *
from projectportfolio..nashville_housing

--standardizing Date Format

 select saledateconverted, convert(date,saledate)
from projectportfolio..nashville_housing

alter table projectportfolio..nashville_housing
add saledateconverted date ;

update projectportfolio..nashville_housing
set saledateconverted=convert(date,saledate)



--populate property address data
 select *
from projectportfolio..nashville_housing
--where PropertyAddress is null
order by Parcelid

--using a self join (comment further)
 select pn.parcelid, pn.PropertyAddress,ph.ParcelID, ph.PropertyAddress,isnull(pn.PropertyAddress,ph.PropertyAddress)
from projectportfolio..nashville_housing pn
join projectportfolio..nashville_housing ph
on pn.parcelid=ph.parcelid and pn.[UniqueID ] <> ph.[UniqueID ]
where pn.PropertyAddress is null

update pn
set propertyaddress = isnull(pn.PropertyAddress,ph.PropertyAddress)
from projectportfolio..nashville_housing pn
join projectportfolio..nashville_housing ph
on pn.parcelid=ph.parcelid and pn.[UniqueID ] <> ph.[UniqueID ] 
where pn.PropertyAddress is null

--breaking out the address into individual columns(address, city, state)
select propertyaddress
from projectportfolio..nashville_housing

--starting with the street name
select
substring(propertyaddress,1,charindex(',', propertyaddress)-1) as address,
substring(propertyaddress,charindex(',', propertyaddress)+1,len(propertyaddress)) as address
from projectportfolio..nashville_housing

alter table projectportfolio..nashville_housing
add propertySplitStreet Nvarchar(255);

update projectportfolio..nashville_housing
set propertySplitStreet = substring(propertyaddress,1,charindex(',', propertyaddress)-1)

alter table projectportfolio..nashville_housing
add propertySplitcity Nvarchar(255);

update projectportfolio..nashville_housing
set propertySplitcity = substring(propertyaddress,charindex(',', propertyaddress)+1,len(propertyaddress))


--confirmation check
select *
from projectportfolio..nashville_housing



--breaking out the owneraddress into individual columns(address, city, state)
-- here we are using parsename its a lot easier than using substring
--however it works with period, hence we need to replace the comma with period 
--its also to important to note that parsename works backwords hence numbering it an desc order
select
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from projectportfolio..nashville_housing
--where OwnerAddress like '%good%'

alter table projectportfolio..nashville_housing
add ownerSplitStreet Nvarchar(255);

update projectportfolio..nashville_housing
set ownerSplitStreet = parsename(replace(owneraddress,',','.'),3)

alter table projectportfolio..nashville_housing
add ownerSplitcity Nvarchar(255);

update projectportfolio..nashville_housing
set ownerSplitcity = parsename(replace(owneraddress,',','.'),2)

alter table projectportfolio..nashville_housing
add ownerSplitstate Nvarchar(255);

update projectportfolio..nashville_housing
set ownerSplitstate = parsename(replace(owneraddress,',','.'),1)

--dropping an obselete column
alter table projectportfolio..nashville_housing
drop column propertySplitstate; 


--confirmation check
select *
from projectportfolio..nashville_housing

select distinct( soldasvacant), count(soldasvacant)
from projectportfolio..nashville_housing
group by soldasvacant
order by 2,1


--fixing the incosistency is the binary response  using the Case operator

select soldasvacant, 
case when soldasvacant = 'Y' then 'yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end 
from projectportfolio..nashville_housing

--then we will update the column in the table 
update projectportfolio..nashville_housing
set SoldAsVacant= case when soldasvacant = 'Y' then 'yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end 


-- confirmation check
select distinct( soldasvacant), count(soldasvacant)
from projectportfolio..nashville_housing
group by soldasvacant
order by 2,1


--remove duplicate
--creating a CTE
with row_checkCTE as(
--finding the duplicate 
select *, 
row_number() over (partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) as checking
from projectportfolio..nashville_housing)
select *
from row_checkCTE
where checking > 1

--to delete
with row_checkCTE as(
--finding the duplicate 
select *, 
row_number() over (partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) as checking
from projectportfolio..nashville_housing)
delete 
from row_checkCTE
where checking > 1

--delete unused columns
select *
from projectportfolio..nashville_housing

alter table projectportfolio..nashville_housing
drop column saledate