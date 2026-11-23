-- 1. data understanding and validation

select *
from brighttv_analytics.brighttv.user_profiles;

select *
from brighttv_analytics.brighttv.viewership;

describe brighttv_analytics.brighttv.user_profiles;

describe brighttv_analytics.brighttv.viewership;

select count(*) as total_users
from brighttv_analytics.brighttv.user_profiles;

select count(*) as total_viewing_records
from brighttv_analytics.brighttv.viewership;


-- 2. data quality checks

select *
from brighttv_analytics.brighttv.user_profiles
where userid is null
or name is null
or surname is null
or email is null
or gender is null
or age is null
or province is null;

select *
from brighttv_analytics.brighttv.viewership
where userid0 is null
or channel2 is null
or recorddate2 is null
or duration_2 is null;

select count(*) as zero_duration
from brighttv_analytics.brighttv.viewership
where duration_2 = '0:00:00';

select count(*) as mismatched_ids
from brighttv_analytics.brighttv.viewership
where userid0 <> userid4;


-- 3. viewership overview

select
    count(*) as total_sessions,
    count(distinct userid0) as unique_users,
    count(distinct channel2) as unique_channels,
    min(recorddate2) as first_viewing_date,
    max(recorddate2) as last_viewing_date
from brighttv_analytics.brighttv.viewership;


-- 4. user and usage trends

select
    channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by channel2
order by total_sessions desc;

select
    recorddate2 as viewing_date,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by recorddate2
order by viewing_date;

select
    date_format(recorddate2, 'yyyy-MM') as month,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'yyyy-MM')
order by month;

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions desc;


-- 5. audience demographics

select
    p.gender,
    count(distinct v.userid0) as unique_viewers
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.gender
order by unique_viewers desc;

select
    p.province,
    count(distinct v.userid0) as unique_viewers
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.province
order by unique_viewers desc;

select
    p.age,
    count(distinct v.userid0) as unique_viewers
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.age
order by p.age;


-- 6. viewer engagement

select
    userid0 as user_id,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by userid0
order by total_sessions desc
limit 20;

select
    channel2 as channel,
    count(distinct userid0) as unique_viewers,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by channel2
order by total_sessions desc;


-- 7. factors influencing consumption

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions desc;

select
    channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by channel2
order by total_sessions desc;

select
    p.gender,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.gender
order by total_sessions desc;

select
    p.province,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.province
order by total_sessions desc;


-- 8. low consumption days

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions asc;

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE'), channel2
order by total_sessions desc;


-- 9. channel preference by gender

select
    p.gender,
    v.channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.gender, v.channel2
order by total_sessions desc;


-- 10. channel preference by province

select
    p.province,
    v.channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.province, v.channel2
order by total_sessions desc;


-- 11. channel preference by age

select
    p.age,
    v.channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.age, v.channel2
order by total_sessions desc;


-- 12. user profile and viewing activity

select
    p.gender,
    count(distinct v.userid0) as unique_viewers,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.gender
order by total_sessions desc;

-- 13.Province + viewing activity
select
    p.province,
    count(distinct v.userid0) as unique_viewers,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.province
order by total_sessions desc;

--14. Age + viewing activity
select
    p.age,
    count(distinct v.userid0) as unique_viewers,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.age
order by total_sessions desc;

-- 15. consumption by day of week

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions desc;


-- 16. consumption by time of day

select
    recorddate2 as viewing_date,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by recorddate2
order by total_sessions desc;


-- 17. top performing channels

select
    channel2 as channel,
    count(*) as total_sessions,
    count(distinct userid0) as unique_viewers
from brighttv_analytics.brighttv.viewership
group by channel2
order by total_sessions desc;


-- 18. low consumption days

select
    recorddate2 as viewing_date,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by recorddate2
order by total_sessions asc;


-- 19. low consumption days of the week

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions asc;

-- 20. monthly consumption trend

select
    date_format(recorddate2, 'yyyy-MM') as month,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'yyyy-MM')
order by month;

-- 21. factors influencing consumption

-- age

select
    p.gender,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.gender
order by total_sessions desc;


select
    p.province,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.province
order by total_sessions desc;


select
    p.age,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership v
join brighttv_analytics.brighttv.user_profiles p
on v.userid0 = p.userid
group by p.age
order by total_sessions desc;


select
    channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by channel2
order by total_sessions desc;


select
    date_format(recorddate2, 'EEEE') as day_of_week,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE')
order by total_sessions desc;

-- 22. recommended content for low consumption days

select
    date_format(recorddate2, 'EEEE') as day_of_week,
    channel2 as channel,
    count(*) as total_sessions
from brighttv_analytics.brighttv.viewership
group by date_format(recorddate2, 'EEEE'), channel2
order by total_sessions desc;


-- 23. initiatives to grow brighttv user base

select
    p.province,
    count(distinct p.userid) as total_users,
    count(distinct v.userid0) as active_viewers,
    count(v.userid0) as total_sessions
from brighttv_analytics.brighttv.user_profiles p
left join brighttv_analytics.brighttv.viewership v
on p.userid = v.userid0
group by p.province
order by total_users desc;
