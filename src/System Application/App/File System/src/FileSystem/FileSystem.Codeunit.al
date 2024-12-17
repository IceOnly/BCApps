// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.FileSystem;

codeunit 9454 "File System"
{
    InherentPermissions = X;
    InherentEntitlements = X;

    var
        FileSystemImpl: Codeunit "File System Impl.";

    /// <summary>
    /// Initialized the File System for the given scenario.
    /// </summary>
    /// <param name="Scenario">File Scenario to use.</param>
    procedure Initialize(Scenario: Enum "File Scenario")
    begin
        FileSystemImpl.Initialize(Scenario);
    end;

    /// <summary>
    /// Initialized the File System for the give file account.
    /// </summary>
    /// <param name="FileAccount"> File Account to use.</param>
    procedure Initialize(FileAccount: Record "File Account")
    begin
        FileSystemImpl.Initialize(FileAccount);
    end;

    /// <summary>
    /// List all files from the given path.
    /// </summary>
    /// <param name="Path">Folder to list</param>
    /// <param name="FilePaginationData">Defines the pagination data.</param>
    /// <param name="FileAccountContent">File account content.</param>
    procedure ListFiles(Path: Text; FilePaginationData: Codeunit "File Pagination Data"; var FileAccountContent: Record "File Account Content" temporary)
    begin
        FileSystemImpl.ListFiles(Path, FilePaginationData, FileAccountContent);
    end;

    /// <summary>
    /// Retrieves a file from the file account.
    /// </summary>
    /// <param name="Path">File Path to open.</param>
    /// <param name="Stream">Stream which contains the file content.</param>
    [TryFunction]
    procedure GetFile(Path: Text; Stream: InStream)
    begin
        FileSystemImpl.GetFile(Path, Stream);
    end;

    /// <summary>
    /// Stores a file in to the file account.
    /// </summary>
    /// <param name="Path">File Path inside the file account.</param>
    /// <param name="Stream">Stream to store.</param>
    [TryFunction]
    procedure CreateFile(Path: Text; Stream: InStream)
    begin
        FileSystemImpl.CreateFile(Path, Stream);
    end;

    /// <summary>
    /// Copies a file in the file account.
    /// </summary>
    /// <param name="SourcePath">Source path of the file.</param>
    /// <param name="TargetPath">Target Path of the file copy.</param>
    [TryFunction]
    procedure CopyFile(SourcePath: Text; TargetPath: Text)
    begin
        FileSystemImpl.CopyFile(SourcePath, TargetPath);
    end;

    /// <summary>
    /// Moves a file in the file account.
    /// </summary>
    /// <param name="SourcePath">Source path of the file.</param>
    /// <param name="TargetPath">Target Path of the file.</param>
    [TryFunction]
    procedure MoveFile(SourcePath: Text; TargetPath: Text)
    begin
        FileSystemImpl.MoveFile(SourcePath, TargetPath);
    end;

    /// <summary>
    /// Checks if a specific file exists in the file account.
    /// </summary>
    /// <param name="Path">File path to check.</param>
    /// <returns>Returns true if the file exists.</returns>
    procedure FileExists(Path: Text): Boolean
    begin
        exit(FileSystemImpl.FileExists(Path));
    end;

    /// <summary>
    /// Deletes a file from the file account.
    /// </summary>
    /// <param name="Path">File path of the file to delete.</param>
    [TryFunction]
    procedure DeleteFile(Path: Text)
    begin
        FileSystemImpl.DeleteFile(Path);
    end;

    /// <summary>
    /// List all directories from the given path.
    /// </summary>
    /// <param name="Path">Folder to list</param>
    /// <param name="FilePaginationData">Defines the pagination data.</param>
    /// <param name="FileAccountContent">File account content.</param>
    [TryFunction]
    procedure ListDirectories(Path: Text; FilePaginationData: Codeunit "File Pagination Data"; var FileAccountContent: Record "File Account Content" temporary)
    begin
        FileSystemImpl.ListDirectories(Path, FilePaginationData, FileAccountContent);
    end;

    /// <summary>
    /// Creates a directory in the file account.
    /// </summary>
    /// <param name="Path">Path of the new Directory to create.</param>
    [TryFunction]
    procedure CreateDirectory(Path: Text)
    begin
        FileSystemImpl.CreateDirectory(Path);
    end;

    /// <summary>
    /// Checks if a specific directory exists in the file account.
    /// </summary>
    /// <param name="Path">Path of the directory to check.</param>
    /// <returns>Returns true if directory exists.</returns>
    procedure DirectoryExists(Path: Text): Boolean
    begin
        exit(FileSystemImpl.DirectoryExists(Path));
    end;

    /// <summary>
    /// Deletes a directory from the file account.
    /// </summary>
    /// <param name="Path">Directory to remove.</param>
    [TryFunction]
    procedure DeleteDirectory(Path: Text)
    begin
        FileSystemImpl.DeleteDirectory(Path);
    end;

    /// <summary>
    /// Combines to paths together.
    /// </summary>
    /// <param name="Path">First part to combine.</param>
    /// <param name="ChildPath">Second part to combine.</param>
    /// <returns>Correctly combined path.</returns>
    procedure CombinePath(Path: Text; ChildPath: Text): Text
    begin
        exit(FileSystemImpl.CombinePath(Path, ChildPath));
    end;

    /// <summary>
    /// Gets the Parent Path of the given path.
    /// </summary>
    /// <param name="Path">File or directory path.</param>
    /// <returns>The parent of the specified path.</returns>
    procedure GetParentPath(Path: Text): Text
    begin
        exit(FileSystemImpl.GetParentPath(Path));
    end;

    /// <summary>
    /// Opens a folder selection dialog.
    /// </summary>
    /// <param name="Path">Start path of the dialog.</param>
    /// <returns>Returns the selected Folder.</returns>
    procedure SelectAndGetFolderPath(Path: Text): Text
    var
        DefaultSelectFolderLbl: Label 'Select a folder';
    begin
        exit(SelectAndGetFolderPath(Path, DefaultSelectFolderLbl));
    end;

    /// <summary>
    /// Opens a folder selection dialog.
    /// </summary>
    /// <param name="Path">Start path of the dialog.</param>
    /// <param name="DialogTitle">Title of the selection dialog.</param>
    /// <returns>Returns the selected Folder.</returns>
    procedure SelectAndGetFolderPath(Path: Text; DialogTitle: Text): Text
    begin
        exit(FileSystemImpl.SelectAndGetFolderPath(Path, DialogTitle));
    end;

    /// <summary>
    /// Opens a select file dialog.
    /// </summary>
    /// <param name="Path">Start path.</param>
    /// <param name="FileFilter">A filter string that applies only on files not on folders.</param>
    /// <returns>Returns the path of the selected file.</returns>
    procedure SelectAndGetFilePath(Path: Text; FileFilter: Text): Text
    var
        DefaultSelectFileUILbl: Label 'Select a file';
    begin
        exit(SelectAndGetFilePath(Path, FileFilter, DefaultSelectFileUILbl));
    end;

    /// <summary>
    /// Opens a select file dialog.
    /// </summary>
    /// <param name="Path">Start path of the dialog.</param>
    /// <param name="FileFilter">A filter string that applies only on files not on folders.</param>
    /// <param name="DialogTitle">Title of the selection dialog.</param>
    /// <returns>Returns the path of the selected file.</returns>
    procedure SelectAndGetFilePath(Path: Text; FileFilter: Text; DialogTitle: Text): Text
    begin
        exit(FileSystemImpl.SelectAndGetFilePath(Path, FileFilter, DialogTitle));
    end;

    /// <summary>
    /// Opens a save to dialog.
    /// </summary>
    /// <param name="Path">Start path of the dialog.</param>
    /// <param name="FileExtension">The file extension without dot (like pdf or txt).</param>
    /// <returns>Returns the selected file path.</returns>
    procedure SaveFile(Path: Text; FileExtension: Text): Text
    var
        DefaultSaveFileTitleLbl: Label 'Save as';
    begin
        exit(SaveFile(Path, FileExtension, DefaultSaveFileTitleLbl));
    end;

    /// <summary>
    /// Opens a save to dialog.
    /// </summary>
    /// <param name="Path">Start path of the dialog.</param>
    /// <param name="FileExtension">The file extension without dot (like pdf or txt).</param>
    ///  <param name="DialogTitle">Title of the selection dialog.</param>
    /// <returns>Returns the selected file path.</returns>
    procedure SaveFile(Path: Text; FileExtension: Text; DialogTitle: Text): Text
    begin
        exit(FileSystemImpl.SaveFile(Path, FileExtension, DialogTitle));
    end;

    /// <summary>
    /// Opens a File Browser
    /// </summary>
    procedure BrowseAccount()
    begin
        FileSystemImpl.BrowseAccount();
    end;
}
