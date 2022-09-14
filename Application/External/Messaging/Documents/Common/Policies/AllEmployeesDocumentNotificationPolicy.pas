unit AllEmployeesDocumentNotificationPolicy;

interface

uses

  Employee,
  EmployeeDocumentNotificationPolicy,
  SysUtils,
  Classes;

type

  TAllEmployeesDocumentNotificationPolicy = class (TInterfacedObject, IEmployeeDocumentNotificationPolicy)

    public

      function CanNotifyEmployeeAboutDocument(
        Employee: TEmployee
      ): Boolean;

  end;

implementation

{ TAllEmployeesDocumentNotificationPolicy }

function TAllEmployeesDocumentNotificationPolicy.CanNotifyEmployeeAboutDocument(
  Employee: TEmployee
): Boolean;
begin

  Result := True;

end;

end.
