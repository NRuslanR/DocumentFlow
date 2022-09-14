unit NoneEmployeeDocumentNotificationPolicy;

interface

uses

  Employee,
  EmployeeDocumentNotificationPolicy,
  SysUtils,
  Classes;

type

  TNoneEmployeeDocumentNotificationPolicy = class (TInterfacedObject, IEmployeeDocumentNotificationPolicy)

    public

      function CanNotifyEmployeeAboutDocument(
        Employee: TEmployee
      ): Boolean;

  end;

implementation

{ TNoneEmployeeDocumentNotificationPolicy }

function TNoneEmployeeDocumentNotificationPolicy.CanNotifyEmployeeAboutDocument(
  Employee: TEmployee): Boolean;
begin

  Result := False;
  
end;

end.
