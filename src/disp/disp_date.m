% Display date and time
% L. LAURENT -- 17/12/2010 -- luc.laurent@lecnam.net

day=clock;
fprintf('=============================================\n');
fprintf('Date: %d/%d/%d   Time: %02.0f:%02.0f:%02.0f\n',...
    day(3), day(2), day(1), day(4), day(5), day(6));
fprintf('=============================================\n');