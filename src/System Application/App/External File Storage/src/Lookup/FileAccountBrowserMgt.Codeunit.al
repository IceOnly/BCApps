// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.ExternalFileStorage;

codeunit 9458 "File Account Browser Mgt."
{
    Access = Internal;
    InherentPermissions = X;
    InherentEntitlements = X;

    var
        FileSystem: Codeunit "External File Storage";

    procedure SetFileAccount(FileAccount: Record "File Account")
    begin
        FileSystem.Initialize(FileAccount);
    end;

    procedure StripNotSupportedCharsInFileName(InText: Text): Text
    var
        InvalidCharsStringTxt: Label '"#%&*:<>?\/{|}~', Locked = true;
    begin
        InText := DelChr(InText, '=', InvalidCharsStringTxt);
        exit(InText);
    end;

    procedure BrowseFolder(var TempFileAccountContent: Record "File Account Content" temporary; Path: Text; var CurrentPath: Text; DoNotLoadFiles: Boolean; FileNameFilter: Text)
    var
        FilePaginationData: Codeunit "File Pagination Data";
    begin
        CurrentPath := Path.TrimEnd('/');
        TempFileAccountContent.DeleteAll();

        repeat
            FileSystem.ListDirectories(Path, FilePaginationData, TempFileAccountContent);
        until FilePaginationData.IsEndOfListing();

        ListFiles(TempFileAccountContent, Path, DoNotLoadFiles, CurrentPath, FileNameFilter);
        if TempFileAccountContent.FindFirst() then;
    end;

    procedure DownloadFile(var TempFileAccountContent: Record "File Account Content" temporary)
    var
        Stream: InStream;
        FileName: Text;
    begin
        FileSystem.GetFile(FileSystem.CombinePath(TempFileAccountContent."Parent Directory", TempFileAccountContent.Name), Stream);
        FileName := TempFileAccountContent.Name;
        DownloadFromStream(Stream, '', '', '', FileName);
    end;

    procedure UploadFile(Path: Text)
    var
        Stream: InStream;
        UploadDialogTxt: Label 'Upload File';
        FromFile: Text;
    begin
        if not UploadIntoStream(UploadDialogTxt, '', '', FromFile, Stream) then
            exit;

        FileSystem.CreateFile(FileSystem.CombinePath(Path, FromFile), Stream);
    end;

    procedure CreateDirectory(Path: Text)
    var
        FolderNameInput: Page "Folder Name Input";
        FolderName: Text;
    begin
        if FolderNameInput.RunModal() <> Action::OK then
            exit;

        FolderName := StripNotSupportedCharsInFileName(FolderNameInput.GetFolderName());
        FileSystem.CreateDirectory(FileSystem.CombinePath(Path, FolderName));
    end;

    local procedure ListFiles(var FileAccountContent: Record "File Account Content" temporary; Path: Text; DoNotLoadFields: Boolean; CurrentPath: Text; FileNameFilter: Text)
    var
        TempFileAccountContentToAdd: Record "File Account Content" temporary;
        FilePaginationData: Codeunit "File Pagination Data";
    begin
        if DoNotLoadFields then
            exit;

        repeat
            FileSystem.ListFiles(Path, FilePaginationData, FileAccountContent);
        until FilePaginationData.IsEndOfListing();

        AddFiles(FileAccountContent, TempFileAccountContentToAdd, CurrentPath, FileNameFilter);
    end;

    local procedure AddFiles(var FileAccountContent: Record "File Account Content" temporary; var FileAccountContentToAdd: Record "File Account Content" temporary; CurrentPath: Text; FileNameFilter: Text)
    begin
        if FileNameFilter <> '' then
            FileAccountContentToAdd.SetFilter(Name, FileNameFilter);

        if FileAccountContentToAdd.FindSet() then
            repeat
                FileAccountContent.Init();
                FileAccountContent.TransferFields(FileAccountContentToAdd);
                FileAccountContent.Insert();
            until FileAccountContentToAdd.Next() = 0;

        FileAccountContent.Init();
        FileAccountContent.Validate(Name, '..');
        FileAccountContent.Validate(Type, FileAccountContent.Type::Directory);
        FileAccountContent.Validate("Parent Directory", CopyStr(FileSystem.GetParentPath(CurrentPath), 1, MaxStrLen(FileAccountContent."Parent Directory")));
        FileAccountContent.Insert();
    end;

    procedure DeleteFileOrDirectory(var TempFileAccountContent: Record "File Account Content" temporary)
    var
        DeleteQst: Label 'Delete %1?', Comment = '%1 - Path to Delete';
        PathToDelete: Text;
    begin
        PathToDelete := FileSystem.CombinePath(TempFileAccountContent."Parent Directory", TempFileAccountContent.Name);
        if not Confirm(DeleteQst, false, PathToDelete) then
            exit;

        case TempFileAccountContent.Type of
            TempFileAccountContent.Type::Directory:
                FileSystem.DeleteDirectory(PathToDelete);
            TempFileAccountContent.Type::File:
                FileSystem.DeleteFile(PathToDelete);
        end;
    end;

    internal procedure CombinePath(Path: Text; ChildPath: Text): Text
    begin
        exit(FileSystem.CombinePath(Path, ChildPath));
    end;
}