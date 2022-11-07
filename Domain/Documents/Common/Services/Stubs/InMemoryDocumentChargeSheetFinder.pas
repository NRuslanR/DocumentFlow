unit InMemoryDocumentChargeSheetFinder;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheetFinder,
  DocumentChargeSheet,
  AbstractDocumentChargeSheetFinder,
  EmployeeDocumentChargeSheetWorkingRules;

type

  TInMemoryDocumentChargeSheetFinder =
    class (TAbstractDocumentChargeSheetFinder)

      private

        FChargeSheets: TDocumentChargeSheets;

        procedure Initialize;

        function InternalFindAllSubordinateChargeSheetsFor(
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheets; override;

      public

        destructor Destroy; override;
        
        constructor Create(
          EmployeeDocumentChargeSheetWorkingRules:
            TEmployeeDocumentChargeSheetWorkingRules
        ); override;

        property ChargeSheets: TDocumentChargeSheets
        read FChargeSheets;
        
    end;
    
implementation

uses

  DateUtils,
  SysUtils,
  Employee,
  Classes,
  IDomainObjectBaseUnit,
  Role;
  
{ TInMemoryDocumentChargeSheetFinder }

constructor TInMemoryDocumentChargeSheetFinder.Create(
  EmployeeDocumentChargeSheetWorkingRules: TEmployeeDocumentChargeSheetWorkingRules);
begin

  inherited;

  Initialize;
  
end;

destructor TInMemoryDocumentChargeSheetFinder.Destroy;
begin

  FreeAndNil(FChargeSheets);
  inherited;

end;

procedure TInMemoryDocumentChargeSheetFinder.Initialize;
var ChargeSheet, ChildSheet1, ChildSheet2: TDocumentChargeSheet;
    Charge1, Charge2, Charge3, Charge4, Charge5, Charge6, Charge7:
      TDocumentChargeSheet;
      
    Performer: TEmployee;
    IssuingEmployee: TEmployee;
    Emp1, Emp2, Emp3, Emp4, Emp5, Emp6, Emp7, Emp8: IDomainObjectBase;
begin

  FChargeSheets := TDocumentChargeSheets.Create;

  IssuingEmployee := TEmployee.Create(1);
  IssuingEmployee.Name := 'Валерий';
  IssuingEmployee.Surname := 'Коротков';
  IssuingEmployee.Patronymic := 'Борисович';
  IssuingEmployee.Role := TRoleMemento.GetEmployeeRole;

  Emp1 := IssuingEmployee;
  
  ChargeSheet := TDocumentChargeSheet.Create(1);

  Charge1 := ChargeSheet;
  
  ChargeSheet.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;
  
  ChargeSheet.IssuingEmployee := IssuingEmployee;
  ChargeSheet.EditingEmployee := IssuingEmployee;

  ChargeSheet.ChargeText := 'Проработать';
  ChargeSheet.SetTimeFrameStartAndDeadline(
    Now, IncWeek(Now)
  );
  ChargeSheet.TopLevelChargeSheetId := 100;

  Performer := TEmployee.Create(2);

  Emp2 := Performer;

  Performer.Name := 'Иван';
  Performer.Surname := 'Иванов';
  Performer.Patronymic := 'Иванович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChargeSheet.Performer := Performer;

  FChargeSheets.AddDocumentChargeSheet(ChargeSheet);

  ChildSheet1 := TDocumentChargeSheet.Create(2);

  Charge2 := ChildSheet1;
  
  ChildSheet1.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;
  ChildSheet1.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet1.EditingEmployee := ChildSheet1.IssuingEmployee;

  ChildSheet1.ChargeText := 'документы проверить';

  ChildSheet1.SetTimeFrameStartAndDeadline(
    Now, IncMonth(Now)
  );

  ChildSheet1.TopLevelChargeSheetId := ChargeSheet.Identity;

  Performer := TEmployee.Create(3);

  Emp3 := Performer;
  
  Performer.Name := 'Дмитрий';
  Performer.Surname := 'Васильев';
  Performer.Patronymic := 'Борисович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet1.Performer := Performer;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet1);

  ChildSheet2 := TDocumentChargeSheet.Create(3);

  Charge3 := ChildSheet2;
  
  ChildSheet2.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;

  ChildSheet2.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet2.EditingEmployee := ChildSheet2.IssuingEmployee;

  ChildSheet2.ChargeText := 'Что-то ещё сделать';
  ChildSheet2.SetTimeFrameStartAndDeadline(
    Now,
    IncDay(Now, 8)
  );

  Performer := TEmployee.Create(4);

  Emp4 := Performer;
  
  Performer.Name := 'Сергей';
  Performer.Surname := 'Васильев';
  Performer.Patronymic := 'Викторович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet2.Performer := Performer;
  ChildSheet2.TopLevelChargeSheetId := ChargeSheet.Identity;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet2);

  ChargeSheet := ChildSheet1;
  
  ChildSheet1 := TDocumentChargeSheet.Create(4);

  Charge4 := ChildSheet1;

  ChildSheet1.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;
  
  ChildSheet1.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet1.EditingEmployee := ChildSheet1.IssuingEmployee;

  ChildSheet1.ChargeText := 'Сделать немедлено';
  ChildSheet1.SetTimeFrameStartAndDeadline(
    Now, IncDay(Now, 8)
  );

  Performer := TEmployee.Create(5);

  Emp5 := Performer;

  Performer.Name := 'Загит';
  Performer.Surname := 'Кадритов';
  Performer.Patronymic := 'Пердеевич';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet1.Performer := Performer;
  ChildSheet1.TopLevelChargeSheetId := ChargeSheet.Identity;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet1);

  ChildSheet1 := TDocumentChargeSheet.Create(5);

  Charge5 := ChildSheet1;
  
  ChildSheet1.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;
  
  ChildSheet1.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet1.EditingEmployee := ChildSheet1.IssuingEmployee;
  
  ChildSheet1.ChargeText := 'Тестовое поручение';
  ChildSheet1.SetTimeFrameStartAndDeadline(
    Now, IncDay(Now, 8)
  );

  Performer := TEmployee.Create(6);

  Emp6 := Performer;
  
  Performer.Name := 'Алексей';
  Performer.Surname := 'Денисов';
  Performer.Patronymic := 'Викторович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet1.Performer := Performer;
  ChildSheet1.TopLevelChargeSheetId := ChargeSheet.Identity;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet1);

  ChargeSheet := ChildSheet2;

  ChildSheet2 := TDocumentChargeSheet.Create(4);

  Charge6 := ChildSheet2;

  ChildSheet2.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;

  ChildSheet2.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet2.EditingEmployee := ChildSheet2.IssuingEmployee;

  ChildSheet2.ChargeText := 'Произвол !';
  ChildSheet2.SetTimeFrameStartAndDeadline(
    Now, IncDay(Now, 8)
  );

  Performer := TEmployee.Create(7);

  Emp7 := Performer;
  
  Performer.Name := 'Игорь';
  Performer.Surname := 'Роньжин';
  Performer.Patronymic := 'Аипович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet2.Performer := Performer;
  ChildSheet2.TopLevelChargeSheetId := ChargeSheet.Identity;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet2);

  ChildSheet2 := TDocumentChargeSheet.Create(4);

  Charge7 := ChildSheet2;
  
  ChildSheet2.WorkingRules := FEmployeeDocumentChargeSheetWorkingRules;

  ChildSheet2.IssuingEmployee := ChargeSheet.Performer;
  ChildSheet2.EditingEmployee := ChildSheet2.IssuingEmployee;

  ChildSheet2.ChargeText := 'Произвол !';
  ChildSheet2.SetTimeFrameStartAndDeadline(
    Now, IncDay(Now, 8)
  );

  Performer := TEmployee.Create(8);

  Emp8 := Performer;
  
  Performer.Name := 'Андрей';
  Performer.Surname := 'Низамов';
  Performer.Patronymic := 'Павлович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChildSheet2.Performer := Performer;
  ChildSheet2.TopLevelChargeSheetId := ChargeSheet.Identity;

  FChargeSheets.AddDocumentChargeSheet(ChildSheet2);

end;

function TInMemoryDocumentChargeSheetFinder.InternalFindAllSubordinateChargeSheetsFor(
  ChargeSheet: IDocumentChargeSheet): TDocumentChargeSheets;
begin

  Result := FChargeSheets;
  
end;

end.
