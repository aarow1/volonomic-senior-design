classdef PersistentMemory < handle
    
%  type | sub 
%  -------------------------------------------------------------
%  11   |  0   format memory
    
properties (SetAccess = private)

end

properties (SetAccess = private, Hidden)
    com
    made_MessageInterface
end

properties (Dependent)

end    

properties (Hidden)
    verbose % verbose mode
end

properties (SetAccess = private)

end

properties (Constant, Hidden)
    % Type
    kTypePersistentMemory      = 11;

    % Subtype
    kSubtypeFormat    =  0;

    % specs for requesting / parsing custom messages with multiple values
    kSpecRequestMessage = struct('Type', PersistentMemory.kTypePersistentMemory,...
        'Fields', struct('command', 'uint8'));
end

methods
    function mem = PersistentMemory(varargin) % constructor
% explicily create the MessageInterface and then pass it in so it can be
% shared
%       com = MessageInterface('COM18', 115200);
%       batt = BatteryMonitor('com', com);
%       motor = BrushlessController('com', com);    
%       mem = PersistentMemory('com',com);
        try
            com        = getArgVal('com',   varargin, []);
        catch err
            if strcmp(err.identifier,'MATLAB:UndefinedFunction')
                error('Cannot find getArgVal in the path.  It might be at http://svn.modlabupenn.org/libraries/Matlab_Utilities (rev 67). Find the directory it is in and use addpath() to make it visible.')
            end
        end

        mem.verbose = getArgVal('verbose', varargin, false);

        if isempty(com)
            com = input(['The BrushlessController class requires a MessageInterface.' char(10) 'Please enter the com port used to talk to the module: '],'s');
        end

        if ischar(com)
            mem.com = MessageInterface(com,460800); %115200
            mem.made_MessageInterface = true;
        elseif isa(com, 'MessageInterface')
            mem.com = com;
            mem.made_MessageInterface = false;
        else
            mem.made_MessageInterface = false;
            error('No communication monitor properly defined.');
        end

        out(mem.verbose, 'Finished initializing battery monitor properties.');
    end % constructor

    function delete(mem) %destructor
       if mem.made_MessageInterface
           mem.com.delete();
       end
    end %destructor        

    %% Setters
    
    function Format(mem)
    % formats the memory
        msg.command = 0;
        mem.com.SendMsg(mem.kSpecRequestMessage, msg);
    end
    
    %% Getters
    
    

end % methods

end