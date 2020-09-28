function send_start_trigger(params)
%%
send_ttl(params,params.starttrig);
WaitSecs(.01);
send_ttl(params,0);

WaitSecs(.02);
send_ttl(params,params.starttrig);
WaitSecs(.01);
send_ttl(params,0);

WaitSecs(.02);
send_ttl(params,params.starttrig);
WaitSecs(.01);
send_ttl(params,0);

WaitSecs(.02);
send_ttl(params,params.starttrig);
WaitSecs(.01);
send_ttl(params,0);
