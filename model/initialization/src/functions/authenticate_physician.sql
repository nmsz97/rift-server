create function ehr.authenticate_physician(
  username text,
  password text
) returns ehr.physician_jwt_token as $$
declare
  physician ehr.physician_login;
begin
  select physicians.* into physician
  from ehr.physician_login as physicians
  where physicians.username = $1;

  if physician.password = $2 then
    return (
      'physician',
      86400,
      physician.physician_id,
      physician.username
    )::ehr.physician_jwt_token;
  else
    return null;
  end if;
end;
$$ language plpgsql strict security definer;

comment on function ehr.authenticate_physician(text, text) is 'Function to authenticate physicians using username and hashed password.';
