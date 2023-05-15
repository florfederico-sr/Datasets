select distinct R.Artist_ID_Rosetta_Id as Id, 
--replace(replace(S.Name,',',''),'"','') as name, 
S.YOB, A.genre_id, likes_streams, listeners_followers, lastmonth_streams, 
case when S.Status_of_Deal__c = 'Not Funded' then '0' else '1' end as deal
from [dbo].[Artist_ID_Rosetta] as R
join [salesforce].[dataset] as S on R.Salesforce_ArtistId = S.Id
join [viberate].[artist] as A on R.Viberate_ArtistId = A.uuid
INNER JOIN (
    SELECT uuid
        ,sum(likes_streams) AS likes_streams            
    FROM [viberate].[streaming_history]
    GROUP BY uuid
    ) AS sh ON sh.uuid = A.uuid
INNER JOIN (
    SELECT uuid
        ,max(listeners_followers) AS listeners_followers             
    FROM [viberate].[followers_history]            
    GROUP BY uuid
    ) AS fh ON fh.uuid = A.uuid
INNER JOIN (
	SELECT uuid, sum(likes_streams) as lastmonth_streams
		FROM [viberate].[streaming_history]
	WHERE month(date) = month(SYSDATETIME())-1
	GROUP BY uuid
) AS lm ON lm.uuid = A.uuid
where 1 = 1
and S.YOB is not null
and Viberate_MatchLevel = 1

